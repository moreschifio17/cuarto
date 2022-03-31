/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(function () {
    panel_datos();
});

function panel_datos() {
    $.ajax({
        url: "panel_datos.php"
    }).done(function (resultado) {
        $("#panel-datos").html(resultado);
        formato_tabla("#tabla_panel_datos", 4);
    });

}

function panel_agregar() {
    $.ajax({
        url: "panel_agregar.php"
    }).done(function (resultado) {
        $("#panel-agregar").html(resultado);
        $("#btn-panel-agregar").click();
    });
}

function panel_modificar(id_pais) {
    $.ajax({
        url: "panel_modificar.php",
        type: "POST",
        data: {
            id_pais: id_pais
        }
    }).done(function (resultado) {
        $("#panel-modificar").html(resultado);
        $("#btn-panel-modificar").click();
    });
}


function agregar_grabar() {
    $("#operacion").val(1);
    grabar();
}
function modificar_grabar() {
    $("#operacion").val(2);
    grabar();
    
}

function activar_grabar(id_pais) {
    $("#id_pais").val(id_pais);
    $("#operacion").val(3);
    grabar();
}

function inactivar_grabar(id_pais) {
    $("#id_pais").val(id_pais);
    $("#operacion").val(4);
    grabar();
}

function grabar() {
    var id_pais = '0';
    var pais_descrip = '';
    var pais_gentilicio = '';
    var pais_codigo = '';
    var operacion = $("#operacion").val();
    if (operacion == '1') {
        pais_descrip = $("#agregar_pais_descrip").val();
        pais_gentilicio = $("#agregar_pais_gentilicio").val();
        pais_codigo = $("#agregar_pais_codigo").val();

    }
    
    if(operacion == '2'){
        id_pais = $("#modificar_id_pais").val();
        pais_descrip = $("#modificar_pais_descrip").val();
        pais_gentilicio = $("#modificar_pais_gentilicio").val();
        pais_codigo = $("#modificar_pais_codigo").val();
    }
    
    if (operacion == '3' || operacion == '4') {
        id_pais = $("#id_pais").val();
    }
    
    $.ajax({
        url: "grabar.php",
        type: "POST",
        data: {
            id_pais: id_pais,
            pais_descrip: pais_descrip,
            pais_gentilicio: pais_gentilicio,
            pais_codigo: pais_codigo,
            operacion: operacion
        }
    }).done(function (resultado) {
        if (verificar_mensaje(resultado)) {
            postgrabar(operacion);
        }
        
    });

}

function postgrabar(operacion) {
    panel_datos();
    if (operacion == '1') {
        $("#btn-cerrar-agregar").click();
    }
    if (operacion == '2') {
        $("#btn-cerrar-modificar").click();
    }
}



function formato_tabla(tabla, cantidad) {
    $(tabla).DataTable({
        "lengthChange": false,
        responsive: "true",
        "iDisplayLength": cantidad,
        language: {
            "sSearch": "Buscar: ",
            "sInfo": "Mostrando resultados del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoFiltered": "(filtado de entre _MAX_ registros)",
            "sInfoEmoty": "No hay resultados",
            "oPaginate": {
                "sNext": "Siguiente",
                "sPrevious": "Anterior",
            }
        }

    });
}




