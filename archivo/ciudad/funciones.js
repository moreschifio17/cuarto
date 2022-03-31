
$(function () {
    panel_datos();
});

function refrescar_select() {
    $(".select2").select2();
    $(".select2").attr("style", "width: 100%;");
}


function panel_datos() {
    $.ajax({
        url: "panel_datos.php"
    }).done(function (resultado) {
        $("#panel-datos").html(resultado);
        formato_tabla("#tabla_panel_datos", 2);
    });
}

function panel_agregar() {
    $.ajax({
        url: "panel_agregar.php"
    }).done(function (resultado) {
        $("#panel-agregar").html(resultado);
        $("#btn-panel-agregar").click();
        $("#agregar_ciudad_descrip").autocomplete(false);
        refrescar_select();
    });
}

function panel_modificar(id_ciudad) {
    $.ajax({
        url: "panel_modificar.php",
        type: "POST",
        data: {
            id_ciudad: id_ciudad
        }
    }).done(function (resultado) {
        $("#panel-modificar").html(resultado);
        $("#btn-panel-modificar").click();
        refrescar_select();
    });
}

function formato_tabla(tabla, cantidad) {
    $(tabla).DataTable({
        "lengthChange": false,
        responsive: "true",
        "iDisplayLength": cantidad,
        language: {
            "sSearch": "Buscar: ",
            "sInfo": "Mostrando resultados del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoFiltered": "(filtrado de entre _MAX_ registros)",
            "sInfoEmpty": "No hay resultados",
            "oPaginate": {
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            }
        }
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
    $("#id_ciudad").val(id_pais);
    $("#operacion").val(3);
    grabar();
}

function inactivar_grabar(id_pais) {
    $("#id_ciudad").val(id_pais);
    $("#operacion").val(4);
    grabar();
}

function grabar() {
    var id_ciudad = '0';
    var ciudad_descrip = '';
    var id_pais = '';
    var operacion = $("#operacion").val();
    if (operacion == '1') {
        ciudad_descrip = $("#agregar_ciudad_descrip").val();
        id_pais = $("#agregar_id_pais").val();
    }
    if (operacion == '2') {
        id_ciudad = $("#modificar_id_ciudad").val();
        ciudad_descrip = $("#modificar_ciudad_descrip").val();
        id_pais = $("#modificar_pais_id").val();
    }
    if (operacion == '3' || operacion == '4') {
        id_ciudad = $("#id_ciudad").val();
    }
    $.ajax({
        url: "grabar.php",
        type: "POST",
        data: {
            id_ciudad: id_ciudad,
            ciu_descrip: ciudad_descrip,
            id_pais: id_pais,
            operacion: operacion
        }
    }).done(function (resultado) {
        postgrabar(operacion);
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