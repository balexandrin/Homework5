# Homework5
Скрипт выводит пользователю информацию об имеющихся на момент запуска процессах.
Состав информации определяется ключами, с которыми запущен скрипт.
- без ключей - буде выведена основная информация о всех процессах:
 PID - идентификатор процесса, PPid - идентификатор родительского процесса,Name - имя процесса, исполняемый файл процесса.
 - PID=[PID] - будет выведена информация только о процесе с идентификатором [PID].При указании нескольу=ких [PID] будет выведена информация о последнем из введенных.
 - reUID - будет выведен real UID каждого процесса
 - efUID - будет выведен effective UID каждого процесса
 - ssUID - будет выведен saved set UID каждого процесса
 - fsUID - будет выведен file system UID каждого процесса
 - res - 
        vres=1
        ;;
        fl-n-lib)
        vmaps=1
        ;;
        statmem)
        vstatm=1
        ;;
        *)
        vPID=$(echo $i | awk -F"=" '{print $2};')
