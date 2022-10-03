; Instituto Tecnologico de Costa Rica 
; Jose David Fernandez Salas #2022045079 
; Arquitectura de Computadores IC3101 
; Profesor: Kirstein Gätjens S.
; Tarea Numeros MultiIdioma
; Fecha: 07/10/2022

; ------------------------------Manual-Usuario--------------------------------------

; ------------------------------Auto-Evaluacion-------------------------------------

;-----------------------------------------------------------------------------------

datos segment

    ; esferalanca          db 'E'
    ; cuboBlanco           db 'C'
    ; conoBlanco           db 'V'
    ; cilindroBlanco       db 'D'
    ; esferaNegra          db 'e'
    ; cuboNegro            db 'c'
    ; conoNegro            db 'v'
    ; cilindroNegro        db 'd'

    bufferTablero        db "....", 10, "....", 10, "....", 10, "...."

    filasTab             dw 4
    columnasTab          dw 4

    Ruta                 db "K:\archivos\Rata.TXT",0
    nombArchivo          db "QUANTIK.TXT",0
    handleE              dw ?
    handleS              dw ?

    msgProgramClose      db "Se termino la ejecucion del programa",10,13,'$'
    msgCrearInicio       db "Se va a crear una nueva partida",10,13,'$'
    msgNoSobrescribir    db "No se va a sobrescribir el tablero",10,13,'$'
    msgTableroCreado     db "No se va a sobrescribir el tablero",10,13,'$'
    msgErrorCrearTablero db "Hubo un error en la creacion del tablero",10,13,'$'
    inputArchivo         db "Ya existe tablero, si quiere reiniciarlo opima S, sino cualquier tecla",10,13,'$'

    enterMsg             db " ",10,13,'$'

datos endS

pila segment stack 'stack'
         dw 256 dup(?)
pila endS


codigo segment
                         Assume CS:codigo,DS:datos,SS:pila

enterCall proc near
                         mov    ah, 09h
                         lea    dx, enterMsg                  ;Hace un enter
                         int    21h
                         ret
enterCall endP

crearTablero proc near
    
    createFile1:         mov    ah, 3CH                       ;Crea un nuevo archivo
                         xor    cx, cx
                         lea    dx, nombArchivo
                         int    21h
                         jc     errorTablero

    generalAddBuffer:    mov    handleS, ax
                       
                         mov    ah, 40h                       ;Se agrega la data normal
                         mov    cx,19
                         lea    dx, bufferTablero
                         int    21h

    cerrarFile1:         mov    ah, 3Eh                       ; cerrar el archivo cesar
                         mov    bx, handleS
                         int    21h

                         mov    ah, 09h
                         lea    dx, msgTableroCreado
                         int    21h

                         jmp    terminar
                                         
    errorTablero:        lea    dx, msgErrorCrearTablero
                         mov    ah, 09h
                         int    21h

    terminar:            ret
                      
crearTablero endp

verificarTablero proc near
                         lea    dx,nombArchivo
                         mov    ax,3D00h
                         int    21h
                         jnc    existenteError

    crearPartida:        mov    ah,3Ch
                         xor    cx,cx
                         lea    dx, nombArchivo
                         int    21h
                         jc     errorSobreEcribir
                         mov    handleS,ax
    ;************************************************************
    existenteError:      
                         mov    ah, 09h
                         lea    dx, inputArchivo
                         int    21h
                        
                         mov    ah,01h
                         int    21h
                         cmp    al, 83
                         je     escribirTableroNuevo
                         jmp    errorSobreEcribir

                         
    escribirTableroNuevo:mov    bx, handleS
                         mov    ah, 40h
                         mov    cx,19
                         lea    dx,bufferTablero
                         int    21h

    cerrarTableroCreado: mov    ah,3Eh
                         mov    bx,handleS
                         int    21h
                         ret

    errorSobreEcribir:   lea    dx, msgNoSobrescribir
                         mov    ah, 09h
                         int    21h

                         mov    ax,4C00h
                         int    21h
verificarTablero endp

    main:                mov    ax, ds
                         mov    es, ax
                         mov    ax, datos
                         mov    ds, ax
                         mov    ax, pila
                         mov    ss, ax

                         call   verificarTablero

                         mov    ah, 09h
                         lea    dx, msgProgramClose
                         int    21h

                         mov    ax, 4C00h
                         int    21h
codigo ends

end main                                
