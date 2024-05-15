// Include gtk
#include <gtk/gtk.h>
#include <stdio.h>


double hord(double (*func)(double), double a, double b, size_t iters, double y) {
    double result;
    double tmp;
    // nextx: Реализует формулу: xi+1 = xi - (b - xi) * (f(xi) - y) / (f(b) - f(xi))
    asm volatile (
                  "cmpq $0x00, %%rcx   \n\t"
                  "je end              \n\t"
                  "cycle:              \n\t" // Цикл по числу итераций
                  "    jmp nextx      \n\t" // Считаем следующее приближение x
                  "loopcycle:           \n\t"
                  "    loop cycle      \n\t"
                  "jmp end             \n\t" // После цикла в конец
                  "nextx:              \n\t"
                  "    movsd %1, %%xmm0 \n\t" // Передаем xi как аргумент
                  "    call *%6        \n\t" // В rax - f(xi)
                  "    movsd %%xmm0, %5  \n\t" // Перекидываем f(xi) в стек FPU через временную переменную
                  "    fldl %5         \n\t" // В текущем стеке (f(xi))
                  
                  "    movq %2, %%xmm0 \n\t" // Передаем b как аргумент
                  "    call *%6        \n\t" // В rax - f(b)
                  "    movq %%xmm0, %5  \n\t"
                  "    fldl %5         \n\t" // В текущем стеке (f(xi), f(b))
                  
                  "    fsubp           \n\t" // В текущем стеке (f(b) - f(xi))
                  
                  "    fldl %2         \n\t" // Кладем в стек b
                  "    fsubl %1        \n\t" // В текущем стеке (f(b) - f(xi), b - xi)
                  
                  "    movq %1, %%xmm0 \n\t" // Передаем xi как аргумент
                  "    call *%6        \n\t" // В rax - f(xi)
                  "    movq %%xmm0, %5  \n\t"
                  "    fldl %5         \n\t" // Помещаем f(xi) в стек
                  
                  "    fsubl %4        \n\t" // В текущем стеке (f(b) - f(xi), b - xi, f(xi) - y)
                  "    fmulp           \n\t" // В текущем стеке (f(b) - f(xi), (b - xi) * (f(xi) - y))
                  "    fdivp           \n\t" // В текущем стеке ((b - xi) * (f(xi) - y) / (f(b) - f(xi)))
                  "    fldl %1         \n\t" // Кладем в стек xi
                  "    fsubp           \n\t" // В текущем стеке (xi - (b - xi) * (f(xi) - y) / (f(b) - f(xi)))
                  "    fstpl %1        \n\t" // Записываем просчитанный xi+1 в xi
                  "    jmp loopcycle   \n\t"
                  "end:                \n\t"
                  "    fldl %1         \n\t" // Переносим через стек xi в result
                  "    fstpl %0        \n\t"
                  : "=m" (result)
                  : "m" (a), "m" (b), "c" (iters), "m" (y), "m" (tmp), "m" (func)
    );
    return result;
}

double sinfunc(double x) {
    double result;
    asm volatile ("movq $0x2, %0 \n\t"
                  "fildl %0 \n\t"
                  "movq $0x5, %0 \n\t"
                  "fildl %0 \n\t"
                  "fldl %1 \n\t"
                  "fldl %1 \n\t"
                  "fmulp \n\t"
                  "fsubp \n\t"
                  "fsin \n\t"
                  "fmulp \n\t"
                  "fstpl %0 \n\t"
                  : "=m" (result)
                  : "g" (x)
    );

    return result;
}

void gtk_calculate(GtkWidget *widget) {
    // GList *children = gtk_container_get_children(GTK_CONTAINER(box));
    GtkWidget *spin_a, *spin_b, *spin_iters, *spin_y;
    // spin_a = get_first_child(box);
    spin_a = gtk_grid_get_child_at(GTK_GRID(widget), 0, 1);
    spin_b = gtk_grid_get_child_at(GTK_GRID(widget), 0, 3);
    spin_iters = gtk_grid_get_child_at(GTK_GRID(widget), 1, 1);
    spin_y = gtk_grid_get_child_at(GTK_GRID(widget), 1, 3);
    double a = gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_a));
    double b = gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_b));
    int iters = gtk_spin_button_get_value_as_int(GTK_SPIN_BUTTON(spin_iters));
    double y = gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_y));
    printf("a = %f\n", gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_a)));
    printf("b = %f\n", gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_b)));
    printf("iters = %f\n", gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_iters)));
    printf("y = %f\n", gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_y)));
    double res = hord(sinfunc, a, b, iters, y);
    printf("res = %f\n", res);
     GtkWidget *label_res = gtk_grid_get_child_at(GTK_GRID(widget), 0, 4);
    char res_str[100];
    sprintf(res_str, "Result = %f", res);
    gtk_label_set_text(GTK_LABEL(label_res), res_str);
    return;
}


static void on_activate (GtkApplication *app) {
  // Create a new window
  GtkWidget *window = gtk_application_window_new (app);
  GtkWidget *grid = gtk_grid_new ();
  gtk_window_set_child (GTK_WINDOW (window), grid);


  GtkAdjustment *adjustment_a = gtk_adjustment_new (2.500, -100.0, 100.0, 0.001, 0.1, 0.0);
  GtkAdjustment *adjustment_b = gtk_adjustment_new (2.500, -100.0, 100.0, 0.001, 0.1, 0.0);
  GtkAdjustment *adjustment_iters = gtk_adjustment_new (0, 0.0, 100.0, 1.0, 5.0, 0.0);
  GtkAdjustment *adjustment_y = gtk_adjustment_new (2.500, -100.0, 100.0, 0.001, 0.1, 0.0);
  
  GtkWidget *spin_a = gtk_spin_button_new (adjustment_a, 0.001, 3);
  GtkWidget *spin_b = gtk_spin_button_new (adjustment_b, 0.001, 3);
  GtkWidget *spin_iters = gtk_spin_button_new (adjustment_iters, 1.0, 0);
  GtkWidget *spin_y = gtk_spin_button_new (adjustment_y, 0.001, 3);

  GtkWidget *label_a = gtk_label_new ("Left:");
  GtkWidget *label_b = gtk_label_new ("Right:");
  GtkWidget *label_iters = gtk_label_new ("Iterations:");
  GtkWidget *label_y = gtk_label_new ("Y value:");
  GtkWidget *label_res = gtk_label_new ("Result = ");

  // Create a new button
  GtkWidget *calc_button = gtk_button_new_with_label ("Рассчитать");
  // When the button is clicked, close the window passed as an argument
  g_signal_connect_swapped (calc_button, "clicked", G_CALLBACK (gtk_calculate), grid);
  // Create a new button
  GtkWidget *exit_button = gtk_button_new_with_label ("Выход");
  // When the button is clicked, close the window passed as an argument
  g_signal_connect_swapped (exit_button, "clicked", G_CALLBACK (gtk_window_close), window);
  
  gtk_grid_attach (GTK_GRID (grid), label_a, 0, 0, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), spin_a, 0, 1, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), label_b, 0, 2, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), spin_b, 0, 3, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), label_iters, 1, 0, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), spin_iters, 1, 1, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), label_y, 1, 2, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), spin_y, 1, 3, 1, 1);
  gtk_grid_attach (GTK_GRID (grid), calc_button, 2, 0, 1, 2);
  gtk_grid_attach (GTK_GRID (grid), exit_button, 2, 2, 1, 2);
  gtk_grid_attach (GTK_GRID (grid), label_res, 0, 4, 4, 1);
  
  spin_a = gtk_grid_get_child_at(GTK_GRID(grid), 0, 0);
  
  gtk_window_present (GTK_WINDOW (window));
}

int main (int argc, char *argv[]) {
  // Create a new application
  GtkApplication *app = gtk_application_new (NULL,
                                             G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect (app, "activate", G_CALLBACK (on_activate), NULL);
  return g_application_run (G_APPLICATION (app), argc, argv);
}
