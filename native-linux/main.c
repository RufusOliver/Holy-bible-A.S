#include <gtk/gtk.h>
#include <webkit2/webkit2.h>
#include <limits.h>
#include <unistd.h>

static gchar *resource_path(void) {
    gchar executable[PATH_MAX];
    ssize_t length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);

    if (length > 0) {
        executable[length] = '\0';
        gchar *bin_dir = g_path_get_dirname(executable);
        gchar *path = g_build_filename(bin_dir, "..", "share", "holy-bible-a-s", "index.html", NULL);
        g_free(bin_dir);
        if (g_file_test(path, G_FILE_TEST_EXISTS)) {
            return path;
        }
        g_free(path);
    }

    return g_build_filename(g_get_current_dir(), "dist", "index.html", NULL);
}

/* Inside the AppImage the WebKit helper processes are located through a
 * relative path (././lib/webkit2gtk-4.1, patched into the bundled
 * libwebkit2gtk at build time) that resolves against the process working
 * directory, and the bundled GIO TLS modules are off the default search
 * path. Chdir into the image's usr/ directory and export the library paths
 * before any GTK or WebKit call. No-op when not running from the bundle. */
static void relocate_bundled_layout(void) {
    gchar executable[PATH_MAX];
    ssize_t length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);

    if (length <= 0) return;
    executable[length] = '\0';

    gchar *bin_dir = g_path_get_dirname(executable);
    gchar *usr_dir = g_build_filename(bin_dir, "..", NULL);
    g_free(bin_dir);

    gchar *real = realpath(usr_dir, NULL);
    g_free(usr_dir);
    if (real == NULL) return;

    gchar *helpers = g_build_filename(real, "lib", "webkit2gtk-4.1", NULL);
    if (!g_file_test(helpers, G_FILE_TEST_IS_DIR)) {
        g_free(helpers);
        free(real);
        return;
    }
    g_free(helpers);

    chdir(real);

    gchar *lib_dir = g_build_filename(real, "lib", NULL);
    const gchar *existing = g_getenv("LD_LIBRARY_PATH");
    gchar *combined = g_strconcat(lib_dir, ":",
                                  existing != NULL ? existing : "",
                                  NULL);
    g_setenv("LD_LIBRARY_PATH", combined, TRUE);
    g_free(combined);

    gchar *gio_modules = g_build_filename(lib_dir, "gio", "modules", NULL);
    g_free(lib_dir);
    if (g_file_test(gio_modules, G_FILE_TEST_IS_DIR)) {
        g_setenv("GIO_MODULE_DIR", gio_modules, TRUE);
    }
    g_free(gio_modules);

    free(real);
}

static void activate(GtkApplication *application, gpointer user_data) {
    GtkWidget *window = gtk_application_window_new(application);
    gtk_window_set_title(GTK_WINDOW(window), "Holy Bible A.S");
    gtk_window_set_default_size(GTK_WINDOW(window), 1280, 800);
    gtk_window_set_resizable(GTK_WINDOW(window), TRUE);

    WebKitWebView *web_view = WEBKIT_WEB_VIEW(webkit_web_view_new());
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(web_view));

    gchar *path = resource_path();
    gchar *uri = g_filename_to_uri(path, NULL, NULL);
    if (uri != NULL) {
        webkit_web_view_load_uri(web_view, uri);
    }
    g_free(uri);
    g_free(path);

    gtk_widget_show_all(window);
}

int main(int argc, char **argv) {
    relocate_bundled_layout();
    GtkApplication *application = gtk_application_new(
        "com.holybible.app", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(application, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(application), argc, argv);
    g_object_unref(application);
    return status;
}
