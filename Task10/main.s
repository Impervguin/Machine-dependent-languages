# Положения в сетке
.set exit_row, 2
.set exit_column, 2
.set left_border_row, 1
.set left_border_column, 0
.set right_border_row, 3
.set right_border_column, 0
.set iter_row, 1
.set iter_column, 1
.set y_row, 3
.set y_column, 1
.set calculate_row, 0
.set calculate_column, 2

.set left_border_label_column, 0
.set right_border_label_column, 0
.set y_label_column, 1
.set iter_label_column, 1

.set left_border_label_row, 0
.set right_border_label_row, 2
.set y_label_row, 2
.set iter_label_row, 0

.set result_lable_column, 0
.set result_lable_row, 4

# Параметры сетки
.set grid_column_spacing, 20
.set grid_row_spacing, 20
.set grid_margin_top, 10
.set grid_margin_bottom, 10
.set grid_margin_left, 10
.set grid_margin_right, 10


# Параметры спинбоксов
.set border_value, 0
.set border_min, -100
.set border_max, 100
.set border_inc_step, 1
.set border_inc_step_div, 1000


.set y_value, 0
.set y_min, -10
.set y_max, 10
.set y_inc_step, 1
.set y_inc_step_div, 1000

.set iter_value, 10
.set iter_min, 1
.set iter_max, 100
.set iter_inc_step, 1
.set iter_inc_step_div, 1

# Команды
clicked_command: .string "clicked"
activate_command: .string "activate"

# Строки меток, кнопок
exit_button_text: .string "Выход"
calculate_button_text: .string "Вычислить "
left_spinbox_text: .string "Левая граница: "
right_spinbox_text: .string "Правая граница: "
y_spinbox_text: .string "Искомый Y: "
Iterations_spinbox_text: .string "Итерации: "
result_start_text: .string "Левая граница = \nПравая Граница = \nИтерации = \nИскомый Y =\nНайденный X = \nf(x) = "
result_format: .string "Левая граница = %lf\nПравая Граница = %lf\nИтерации = %d\nИскомый Y = %lf\nНайденный X = %lf\nf(x) = %lf\n"

.lcomm result_buffer, 1024


# Адрес приложения
name: .string "com.calculate.GtkApplication"
# rdi - left
# rsi - right
# rdx - y
# rcx - iter
# rbx - func
# result in rax
hord:
    pushq    %rbp
    movq    %rsp, %rbp

    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)

    movq %rcx, %rdx
    cmp $0, %rdx
    je end
    nextx:
        movq -8(%rbp), %rdi
        call *%rbx
        movq %rax, -32(%rbp)
        fldl -32(%rbp)
        

        movq -16(%rbp), %rdi
        call *%rbx
        movq %rax, -32(%rbp)
        fldl -32(%rbp)
    
        fsubp
    
        fldl -16(%rbp)
        fsubl -8(%rbp)
    
        movq -8(%rbp), %rdi
        call *%rbx
        movq %rax, -32(%rbp)
        fldl -32(%rbp)
    
        fsubl -24(%rbp)
        fmulp
        fdivp
        fldl -8(%rbp)
        fsubp
        fstpl -8(%rbp)

        loop nextx
    end:
        movq -8(%rbp), %rax

    leave
    ret

sinfunc:
    pushq    %rbp
    movq    %rsp, %rbp

    subq $16, %rsp

    movq $0x2, -8(%rbp)
    fildl -8(%rbp)
    movq $0x5, -8(%rbp)
    fildl -8(%rbp)
    movq %rdi, -8(%rbp)
    fldl -8(%rbp) 
    fldl -8(%rbp)
    fmulp 
    fsubp 
    fsin 
    fmulp 
    fstpl -8(%rbp)
    movq -8(%rbp), %rax

    leave
    ret
     
to_double:
    pushq    %rbp
    movq    %rsp, %rbp

    subq $16, %rsp
    movq %rdi, -8(%rbp)
    fildl -8(%rbp)
    fstpl -8(%rbp)
    movq -8(%rbp), %rax

    leave
    ret

to_double_division:
    pushq    %rbp
    movq    %rsp, %rbp
    
    subq $16, %rsp
    
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    fildl -16(%rbp)
    fildl -8(%rbp)
    fdivp
    fstpl -8(%rbp)
    movq -8(%rbp), %rax

    leave
    ret

to_int:
    pushq    %rbp
    movq    %rsp, %rbp

    subq $16, %rsp
    
    movq %rdi, -8(%rbp)
    fldl -8(%rbp)
    fistpq -8(%rbp)
    movq -8(%rbp), %rax

    leave
    ret

calculate_func:
    pushq    %rbp
    movq    %rsp, %rbp
    
    subq $48, %rsp
    movq %rdi, -8(%rbp)

    # Получаем левую границу
    movq -8(%rbp), %rdi
    movq $left_border_column, %rsi
    movq $left_border_row, %rdx
    call gtk_grid_get_child_at
    movq %rax, %rdi
    call gtk_spin_button_get_value
    movq %xmm0, %rax
    movq %rax, -16(%rbp)

    # Получаем правую границу
    movq -8(%rbp), %rdi
    movq $right_border_column, %rsi
    movq $right_border_row, %rdx
    call gtk_grid_get_child_at
    movq %rax, %rdi
    call gtk_spin_button_get_value
    movq %xmm0, %rax
    movq %rax, -24(%rbp)

    # Получаем итерации
    movq -8(%rbp), %rdi
    movq $iter_column, %rsi
    movq $iter_row, %rdx
    call gtk_grid_get_child_at
    movq %rax, %rdi
    call gtk_spin_button_get_value
    movq %xmm0, %rdi
    call to_int
    movq %rax, -32(%rbp)

    # Получаем y
    movq -8(%rbp), %rdi
    movq $y_column, %rsi
    movq $y_row, %rdx
    call gtk_grid_get_child_at
    movq %rax, %rdi
    call gtk_spin_button_get_value
    movq %xmm0, %rax
    movq %rax, -40(%rbp)

    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq -32(%rbp), %rcx
    movq -40(%rbp), %rdx

    leaq sinfunc(%rip), %rbx
    call hord
    movq %rax, %xmm3

    movq %rax, %rdi
    call sinfunc
    movq %rax, %xmm4

    leaq result_buffer(%rip), %rdi
    leaq result_format(%rip), %rsi
    movq -16(%rbp), %xmm0
    movq -24(%rbp), %xmm1
    movq -32(%rbp), %rdx
    movq -40(%rbp), %xmm2
    movq $5, %rax
    call sprintf


    # Получаем result метку
    movq -8(%rbp), %rdi
    movq $result_lable_column, %rsi
    movq $result_lable_row, %rdx
    call gtk_grid_get_child_at
    movq %rax, %rdi
    leaq result_buffer(%rip), %rsi
    call gtk_label_set_text

    leave
    ret

app_activate:
    pushq    %rbp
    movq    %rsp, %rbp

    subq $32, %rsp

    # Создаем окно
    call gtk_application_window_new
    movq %rax, %rdi
    movq %rdi, -8(%rbp)

    # Создаем сетку
    call gtk_grid_new
    movq %rax, %rdi
    movq %rdi, -16(%rbp)
    movq -16(%rbp), %rsi
    movq -8(%rbp), %rdi
    call gtk_window_set_child

    # Настраиваем расстояния в сетке
    movq -16(%rbp), %rdi
    movq $grid_column_spacing, %rsi
    call gtk_grid_set_column_spacing
    movq -16(%rbp), %rdi
    movq $grid_row_spacing, %rsi
    call gtk_grid_set_row_spacing

    movq -16(%rbp), %rdi
    movq $grid_margin_bottom, %rsi
    call gtk_widget_set_margin_bottom

    movq -16(%rbp), %rdi
    movq $grid_margin_top, %rsi
    call gtk_widget_set_margin_top

    movq -16(%rbp), %rdi
    movq $grid_margin_left, %rsi
    call gtk_widget_set_margin_start

    movq -16(%rbp), %rdi
    movq $grid_margin_right, %rsi
    call gtk_widget_set_margin_end


    # Создаем кнопку выхода
    leaq exit_button_text(%rip), %rdi
    call gtk_button_new_with_label
    movq %rax, -24(%rbp)

    # Назначаем функцию закрытия окна на кнопку
    movq -8(%rbp), %rcx
    movq -24(%rbp), %rdi
    leaq clicked_command(%rip), %rsi
    movq gtk_window_close@GOTPCREL(%rip), %rdx
    call g_signal_connect_data

    # Ставим кнопку в сетку
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq $exit_column, %rdx
    movq $exit_row, %rcx
    movl $2, %r8d
    movl $2, %r9d
    call gtk_grid_attach


    # Создаем кнопку вычисления
    leaq calculate_button_text(%rip), %rdi
    call gtk_button_new_with_label
    movq %rax, -24(%rbp)

    # Назначаем функцию закрытия окна на кнопку
    movq -16(%rbp), %rcx
    movq -24(%rbp), %rdi
    leaq clicked_command(%rip), %rsi
    leaq calculate_func(%rip), %rdx
    call g_signal_connect_data

    # Ставим кнопку в сетку
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq $calculate_column, %rdx
    movq $calculate_row, %rcx
    movl $2, %r8d
    movl $2, %r9d
    call gtk_grid_attach


    # Создаем параметры для spinbox левой границы
    movq $border_value, %rdi
    call to_double
    movq %rax, %xmm3

    movq $border_inc_step, %rdi
    movq $border_inc_step_div, %rsi
    call to_double_division
    movq %rax, %rdx

    movq $border_max, %rdi
    call to_double
    movq %rax, %rsi

    movq $border_min, %rdi
    call to_double
    movq %rax, %rdi

    movq %rdi, %xmm0
    movq %rsi, %xmm1
    movq %rdx, %xmm2
    call gtk_spin_button_new_with_range
    movq %rax, -24(%rbp)
    
    movq %xmm3, %xmm0
    movq %rax, %rdi
    call gtk_spin_button_set_value

    # ставим spinbox левой границы в сетку
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq $left_border_column, %rdx
    movq $left_border_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем и ставим надпись для spinbox левой границы
    leaq left_spinbox_text(%rip), %rdi
    call gtk_label_new
    movq -16(%rbp), %rdi
    movq %rax, %rsi
    movq $left_border_label_column, %rdx
    movq $left_border_label_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем параметры для spinbox правой границы
    movq $border_value, %rdi
    call to_double
    movq %rax, %xmm3

    movq $border_inc_step, %rdi
    movq $border_inc_step_div, %rsi
    call to_double_division
    movq %rax, %rdx

    movq $border_max, %rdi
    call to_double
    movq %rax, %rsi

    movq $border_min, %rdi
    call to_double
    movq %rax, %rdi

    movq %rdi, %xmm0
    movq %rsi, %xmm1
    movq %rdx, %xmm2
    call gtk_spin_button_new_with_range
    movq %rax, -24(%rbp)
    
    movq %xmm3, %xmm0
    movq %rax, %rdi
    call gtk_spin_button_set_value

    # ставим spinbox правой границы в сетку
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq $right_border_column, %rdx
    movq $right_border_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем и ставим надпись для spinbox правой границы
    leaq right_spinbox_text(%rip), %rdi
    call gtk_label_new
    movq -16(%rbp), %rdi
    movq %rax, %rsi
    movq $right_border_label_column, %rdx
    movq $right_border_label_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем параметры для spinbox итераций
    movq $iter_value, %rdi
    call to_double
    movq %rax, %xmm3

    movq $iter_inc_step, %rdi
    movq $iter_inc_step_div, %rsi
    call to_double_division
    movq %rax, %rdx

    movq $iter_max, %rdi
    call to_double
    movq %rax, %rsi

    movq $iter_min, %rdi
    call to_double
    movq %rax, %rdi

    movq %rdi, %xmm0
    movq %rsi, %xmm1
    movq %rdx, %xmm2
    call gtk_spin_button_new_with_range
    movq %rax, -24(%rbp)
    
    movq %xmm3, %xmm0
    movq %rax, %rdi
    call gtk_spin_button_set_value

    # ставим spinbox итераций в сетку
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq $iter_column, %rdx
    movq $iter_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем и ставим надпись для spinbox итераций
    leaq Iterations_spinbox_text(%rip), %rdi
    call gtk_label_new
    movq -16(%rbp), %rdi
    movq %rax, %rsi
    movq $iter_label_column, %rdx
    movq $iter_label_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем параметры для spinbox y
    movq $y_value, %rdi
    call to_double
    movq %rax, %xmm3

    movq $y_inc_step, %rdi
    movq $y_inc_step_div, %rsi
    call to_double_division
    movq %rax, %rdx

    movq $y_max, %rdi
    call to_double
    movq %rax, %rsi

    movq $y_min, %rdi
    call to_double
    movq %rax, %rdi

    movq %rdi, %xmm0
    movq %rsi, %xmm1
    movq %rdx, %xmm2
    call gtk_spin_button_new_with_range
    movq %rax, -24(%rbp)
    
    movq %xmm3, %xmm0
    movq %rax, %rdi
    call gtk_spin_button_set_value

    # ставим spinbox y в сетку
    movq -16(%rbp), %rdi
    movq -24(%rbp), %rsi
    movq $y_column, %rdx
    movq $y_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем и ставим надпись для spinbox y
    leaq y_spinbox_text(%rip), %rdi
    call gtk_label_new
    movq -16(%rbp), %rdi
    movq %rax, %rsi
    movq $y_label_column, %rdx
    movq $y_label_row, %rcx
    movl $1, %r8d
    movl $1, %r9d
    call gtk_grid_attach

    # Создаем метку результата:
    leaq result_start_text(%rip), %rdi
    call gtk_label_new
    movq -16(%rbp), %rdi
    
    movq %rax, %rsi
    movq $result_lable_column, %rdx
    movq $result_lable_row, %rcx
    movl $4, %r8d
    movl $2, %r9d
    call gtk_grid_attach
    




    # Делаем окно видимым
    mov -8(%rbp), %rdi
    call gtk_window_present

    movq %rbp, %rsp
    popq %rbp
    ret

.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp

    subq $16, %rsp # Выделяем память на стеке под переменные


    movq $0, %rsi
    leaq name(%rip), %rdi
    call gtk_application_new
    movq %rax, %rdi

    movq %rdi, -8(%rbp)
    leaq activate_command(%rip), %rsi
    leaq app_activate(%rip), %rdx
    movq $0, %rcx
    call g_signal_connect_data

    mov -8(%rbp), %rdi
    movq $0, %rsi
    movq $0, %rdx
    call g_application_run

    movq %rbp, %rsp
    popq %rbp
    ret

.section	.note.GNU-stack,"",@progbits

