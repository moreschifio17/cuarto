
$(function(){
    panel_presupuestos();
    panel_datos(-1);
});

function refrescar_select(){
    $(".select2").select2();
    $(".select2").attr("style", "width: 100%;");
}

function formato_tabla(tabla, cantidad){
    $(tabla).DataTable({
        "lengthChange": false,
        responsive: "true",
        "iDisplayLength": cantidad,
        language: {
            "sSearch":"Buscar: ",
            "sInfo":"Mostrando resultados del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoFiltered":"(filtrado de entre _MAX_ registros)",
            "sInfoEmpty":"No hay resultados",
            "oPaginate":{
                "sNext":"Siguiente",
                "sPrevious":"Anterior"
            }
        }
    });
}

function panel_presupuestos(){
    $.ajax({
        url:"panel_presupuestos.php"
    }).done(function(resultado){
        $("#panel-presupuestos").html(resultado);
        formato_tabla("#tabla_panel_presupuestos", 3);
    });
}

function panel_datos(id_cpre){
    $.ajax({
        url:"panel_datos.php",
        type:"POST",
        data:{
            id_cpre: id_cpre
        }
    }).done(function(resultado){
        $("#panel-datos").html(resultado);
        refrescar_select();
    });
}

function modificar_detalle(id_art){
    var id_cpre = $("#id_cpre").val();
    $.ajax({
        url:"panel_modificar.php",
        type:"POST",
        data:{
            id_cpre: id_cpre,
            id_art: id_art
        }
    }).done(function(resultado){
        $("#panel-modificar").html(resultado);
        $("#btn-panel-modificar").click();
    });
}

function datos(id_cp){
    panel_datos(id_cp);
    $("#btn-panel-datos").click();
}

function agregar(){
    panel_datos(0);
    $("#btn-panel-datos").click();
}

function agregar_grabar(){
    $("#operacion").val(1);
    grabar();
}

function modificar(){
    $("#operacion").val(2);
    grabar();
}

function confirmar(){
    $("#operacion").val(3);
    grabar();
}

function anular(){
    $("#operacion").val(4);
    grabar();
}

function agregar_detalles(){
    $("#operacion").val(5);
    grabar();
}

function modificar_detalle_grabar(){
    $("#operacion").val(6);
    grabar();
}

function eliminar_detalle(id_art){
    $("#eliminar_id_art").val(id_art);
    $("#operacion").val(7);
    grabar();
}

function agregar_pedido(id_cp){
    //alert(id_cp);
    $("#agregar_id_cp").val(id_cp);
    $("#operacion").val(8);
    grabar();
}

function cancelar(){
    panel_datos(-1);
    $("#btn-panel-presupuestos").click();
    mensaje("CANCELADO","error");
}

function grabar(){
    var operacion = $("#operacion").val();
    var id_cpre = '0';
    var cpre_fecha = '2021-01-01';
    var cpre_validez = '2021-01-01';
    var cpre_numero = '0';
    var cpre_observacion = '';
    var id_pro = '0';
    var id_art = '0';
    var cantidad = '0';
    var precio = '0';
    var id_cp = '0';
    if(operacion == '1' || operacion == '2' || operacion == '3' || operacion == '4'){
        id_cpre = $("#id_cpre").val();
        cpre_fecha = $("#cpre_fecha").val();
        cpre_validez = $("#cpre_validez").val();
        cpre_numero = $("#cpre_numero").val();
        cpre_observacion = $("#cpre_observacion").val();
        id_pro = $("#id_pro").val();
    }
    if(operacion == '5'){
        id_cpre = $("#id_cpre").val();
        id_art = $("#agregar_id_art").val();
        cantidad = $("#agregar_cantidad").val();
        precio = $("#agregar_precio").val();
    }
    if(operacion == '6'){
        id_cpre = $("#id_cpre").val();
        id_art = $("#modificar_id_art").val();
        cantidad = $("#modificar_cantidad").val();
        precio = $("#modificar_precio").val();
    }
    if(operacion == '7'){
        id_cpre = $("#id_cpre").val();
        id_art = $("#eliminar_id_art").val();
    }
    if(operacion == '8'){
        id_cpre = $("#id_cpre").val();
        id_cp = $("#agregar_id_cp").val();
    }
    $.ajax({
        url: "grabar.php",
        type: "POST",
        data:{
            id_cpre: id_cpre,
            cpre_fecha: cpre_fecha,
            cpre_validez: cpre_validez,
            cpre_numero: cpre_numero,
            cpre_observacion: cpre_observacion,
            id_pro: id_pro,
            id_art: id_art,
            cantidad: cantidad,
            precio: precio,
            id_cp: id_cp,
            operacion: operacion
        }
    }).done(function(resultado){
        if(verificar_mensaje(resultado)){
            postgrabar(operacion);
        }
    });
}

function postgrabar(operacion){
    panel_presupuestos();
    if(operacion == '1'){
        panel_datos(-2);
    }
    if(operacion == '2' || operacion == '5' || operacion == '6' || operacion == '7' || operacion == '8'){
        panel_datos($("#id_cpre").val());
        if(operacion == '6'){
            $("#btn-panel-modificar-cerrar").click();
        }
    }
    if(operacion == '3' || operacion == '4'){
        panel_datos(-1);
        $("#btn-panel-presupuestos").click();
    }
}