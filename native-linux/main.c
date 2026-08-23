#include <gtk/gtk.h>
#include <webkit2/webkit2.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
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
    GtkApplication *application = gtk_application_new(
        "com.holybible.app", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(application, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(application), argc, argv);
    g_object_unref(application);
    return status;
}
