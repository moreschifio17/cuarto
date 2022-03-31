
$(function(){
    panel_datos();
});

function refrescar_select(){
    
    $(".select2").select2();
    $(".select2").attr("style", "width: 100%;");
}

function agregar_persona_fisica(){
    var tipo_persona = '';
    if($("#agregar_persona_fisica").prop('checked')){
        tipo_persona = '1';
    }else{
        tipo_persona = '2';
    }
    $.ajax({
        url:"persona_fisica.php",
        type: "POST",
        data:{
            accion: '1',
            tipo_persona: tipo_persona,
            id_per: '0'
        }
    }).done(function(resultado){
        $("#panel-agregar-persona-fisica").html(resultado);
        refrescar_select();
    });
}

function panel_datos(){
    $.ajax({
        url:"panel_datos.php"
    }).done(function(resultado){
        $("#panel-datos").html(resultado);
        formato_tabla("#tabla_panel_datos", 3);
    });
}

function panel_agregar(){
    $.ajax({
        url:"panel_agregar.php"
    }).done(function(resultado){
        $("#panel-agregar").html(resultado);
        $("#btn-panel-agregar").click();
    });
}

function panel_modificar(id_per){
    $.ajax({
        url: "panel_modificar.php",
        type: "POST",
        data:{
            id_per: id_per
        }
    }).done(function(resultado){
        $("#panel-modificar").html(resultado);
        $("#btn-panel-modificar").click();
        refrescar_select();
    });
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

function agregar_grabar(){
    $("#operacion").val(1);
    grabar();
}

function modificar_grabar(){
    $("#operacion").val(2);
    grabar();
}

function activar_grabar(id_pais){
    $("#id_per").val(id_pais);
    $("#operacion").val(3);
    grabar();
}

function inactivar_grabar(id_pais){
    $("#id_per").val(id_pais);
    $("#operacion").val(4);
    grabar();
}

function grabar(){
    var operacion = $("#operacion").val();
    var id_per = '0';
    var per_ruc = '';
    var per_ci = '';
    var per_nombre = '';
    var per_apellido = '';
    var per_direccion = '';
    var per_correo = '';
    var per_fenaci = '2021-01-01';
    var per_celular = '';
    var per_fisica = 'true';
    var id_ciu = '0';
    var id_ec = '0';
    var id_gen = '0';
    if(operacion == '1'){
        per_ruc = $("#agregar_per_ruc").val();
        per_ci = $("#agregar_per_ci").val();
        per_nombre = $("#agregar_per_nombre").val();
        per_apellido = $("#agregar_per_apellido").val();
        per_direccion = $("#agregar_per_direccion").val();
        per_correo = $("#agregar_per_correo").val();
        per_fenaci = $("#agregar_per_fenaci").val();
        per_celular = $("#agregar_per_celular").val();
        if($("#agregar_persona_fisica").prop('checked')){
            per_fisica = 'true';
        }else{
            per_fisica = 'false';
        }
        id_ciu = $("#agregar_id_ciu").val();
        id_ec = $("#agregar_id_ec").val();
        id_gen = $("#agregar_id_gen").val();
    }
    if(operacion == '2'){
        id_per = $("#modificar_id_per").val();
        per_ruc = $("#modificar_per_ruc").val();
        per_ci = $("#modificar_per_ci").val();
        per_nombre = $("#modificar_per_nombre").val();
        per_apellido = $("#modificar_per_apellido").val();
        per_direccion = $("#modificar_per_direccion").val();
        per_correo = $("#modificar_per_correo").val();
        per_fenaci = $("#modificar_per_fenaci").val();
        per_celular = $("#modificar_per_celular").val();
        id_ciu = $("#modificar_id_ciu").val();
        id_ec = $("#modificar_id_ec").val();
        id_gen = $("#modificar_id_gen").val();
    }
    if(operacion == '3' || operacion == '4'){
        id_per = $("#id_per").val();
    }
    $.ajax({
        url: "grabar.php",
        type: "POST",
        data:{
            id_per: id_per,
            per_ruc: per_ruc,
            per_ci: per_ci,
            per_nombre: per_nombre,
            per_apellido: per_apellido,
            per_direccion: per_direccion,
            per_correo: per_correo,
            per_fenaci: per_fenaci,
            per_celular: per_celular,
            per_fisica: per_fisica,
            id_ciudad: id_ciu,
            id_ec: id_ec,
            id_gen: id_gen,
            operacion: operacion
        }
    }).done(function(resultado){
        if(verificar_mensaje(resultado)){
            postgrabar(operacion);
        }
    });
}

function postgrabar(operacion){
    panel_datos();
    if(operacion == '1'){
        $("#btn-cerrar-agregar").click();
    }
    if(operacion == '2'){
        $("#btn-cerrar-modificar").click();
    }
}