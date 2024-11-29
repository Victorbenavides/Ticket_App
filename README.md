# ticket_app (Sistema de cobro de Tickets)

Esta aplicación fue creada en Flutter para gestionar el cobro de tickets en un evento, ofreciendo un diseño simple y funcional. A continuación, se detalla cada parte del código:

## WEB
## https://ticketapp-inky.vercel.app
## Funcionalidades Principales

1. Cobro de Tickets: Calcula el costo total basado en la cantidad de boletos para niños y adultos.
2. Gestión de Registros: Muestra una lista de los cobros realizados con fecha, hora y detalles de los boletos.
3. Eliminación de Registros: Permite eliminar todos los registros o ajustar cantidades específicas.
4. Visualización de Totales: Muestra el total recaudado y los conteos de boletos vendidos.
5. Créditos: Enlace interactivo a mi GitHub en la parte inferior de la pantalla.

## 1. Configuración Inicial (MaterialApp)
Cuando la aplicación arranca, el main corre la aplicación TicketApp. Esto le dice a Flutter que cargue la app con una interfaz de usuario basada en Material Design. Aquí también 
se define un tema de colores y estilos de texto para toda la app, asegurando una apariencia coherente en cada pantalla.

## 2. Pantalla Principal (TicketHomePage)
La pantalla principal es un StatefulWidget, lo que significa que tiene un estado que puede cambiar a medida que el usuario interactúa. Esta pantalla muestra el costo de los tickets 
(niños y adultos), el total recaudado, y tiene botones para cobrar tickets o eliminar registros.

## 3. Variables de Estado
En el estado de la pantalla, se usan varias variables para gestionar la información:

1. _records: una lista que guarda todos los registros de cobros.
2. _totalChildren, _totalAdults, y _totalRevenue: para llevar el total de niños, adultos y el dinero recaudado.
3. children, adults, amountPaid, total, y change: estas variables son usadas para calcular los valores dentro de los diálogos de agregar un nuevo cobro.

## 4. Agregar Registro de Cobro
Cuando el usuario presiona el botón para cobrar tickets, se muestra un cuadro de diálogo donde el usuario puede ingresar el número de niños y adultos. Se actualiza el total a pagar de 
acuerdo a los valores ingresados (niños cuestan $15 y adultos $30). Después de ingresar esta información, aparece otro cuadro para ingresar cuánto pagó el cliente y calcular el cambio.

## 5. Cálculo de Cambio
Si el monto pagado es suficiente para cubrir el total, se calcula el cambio y se registra el cobro con la fecha y la hora. Ese registro se agrega a la lista de registros y se actualizan 
los totales (niños, adultos y dinero recaudado).

## 6. Eliminar Registros
Si el usuario desea eliminar un registro, se puede hacer de varias maneras:

1. Eliminar todo el registro.
2. Eliminar solo un niño o un adulto de un registro.
3. Eliminar todos los registros a la vez.

Cada una de estas acciones se hace mediante un cuadro de diálogo con opciones, y los totales se actualizan en consecuencia.

## 7. Interfaz de Usuario
El diseño de la interfaz es bastante simple y directa. Tiene botones que llevan a los diálogos de agregar un cobro o eliminar registros, además de mostrar el total recaudado y los totales 
de niños y adultos. También se usa una lista para mostrar todos los registros con su respectiva fecha, número de niños y adultos, y el total cobrado.

## 8. Personalización de Diálogos
Los diálogos (como los de agregar cobros, mostrar el cambio o eliminar registros) son personalizados con colores y textos para que sean fáciles de leer. El color de fondo es oscuro para darle
un estilo más moderno y elegante.

## 9. ListView para Mostrar Registros
Los registros de cobro se muestran en una lista utilizando ListView.builder. Cada registro muestra la fecha, el número de niños y adultos, y el total cobrado.
