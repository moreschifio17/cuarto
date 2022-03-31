<?php
$accion = $_POST['accion'];
$tipo_persona = $_POST['tipo_persona'];
$id_per = $_POST['id_per'];
include '../../conexion.php';
$conexion = Conexion::conectar();
if($accion == '1'){
    if($tipo_persona == '1'){ //PERSONA FISICA
        $ciudades = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_ciudades WHERE estado = 'ACTIVO' AND id_ciudad != 0 ORDER BY pais_descrip, ciu_descrip"));
        $estados_civiles = pg_fetch_all(pg_query($conexion, "SELECT * FROM estados_civiles WHERE estado = 'ACTIVO' AND id_ec != 0 ORDER BY id_ec;"));
        $generos = pg_fetch_all(pg_query($conexion, "SELECT * FROM generos WHERE estado = 'ACTIVO' AND id_gen != 0 ORDER BY gen_descrip;"));
?>
<div class="form-group">
    <label>C.I.</label>
    <input type="text" id="agregar_per_ci" class="form-control">
</div>
<div class="form-group">
    <label>R.U.C.</label>
    <input type="text" id="agregar_per_ruc" class="form-control">
</div>
<div class="form-group">
    <label>Nombre</label>
    <input type="text" id="agregar_per_nombre" class="form-control">
</div>
<div class="form-group">
    <label>Apellido</label>
    <input type="text" id="agregar_per_apellido" class="form-control">
</div>
<div class="form-group">
    <label>Fecha de Nacimiento</label>
    <input type="date" id="agregar_per_fenaci" class="form-control" value="<?php echo date('Y-m-d'); ?>">
	
</div>
<div class="form-group">
    <label>Celular</label>
    <input type="text" id="agregar_per_celular" class="form-control">
</div>
<div class="form-group">
    <label>Correo</label>
    <input type="text" id="agregar_per_correo" class="form-control">
</div>
<div class="form-group">
    <label>Dirección</label>
    <input type="text" id="agregar_per_direccion" class="form-control">
</div>
<div class="form-group">
    <label>Ciudad de Nacimiento</label>
    <select class="select2" id="agregar_id_ciu">
        <?php foreach($ciudades as $c){ ?>
            <option value="<?php echo $c['id_ciudad']; ?>"><?php echo $c['ciu_descrip']." - ".$c['pais_descrip']; ?></option>
        <?php } ?>
    </select>
</div>
<div class="form-group">
    <label>Estado Civil</label>
    <select class="select2" id="agregar_id_ec">
        <?php foreach($estados_civiles as $e){ ?>
            <option value="<?php echo $e['id_ec']; ?>"><?php echo $e['ec_descrip']; ?></option>
        <?php } ?>
    </select>
</div>
<div class="form-group">
    <label>Género</label>
    <select class="select2" id="agregar_id_gen">
        <?php foreach($generos as $g){ ?>
            <option value="<?php echo $g['id_gen']; ?>"><?php echo $g['gen_descrip']; ?></option>
        <?php } ?>
    </select>
</div>
<?php    
    }else{ //PERSONA JURIDICA
?>
<div class="form-group">
    <label>R.U.C.</label>
    <input type="text" id="agregar_per_ruc" class="form-control">
</div>
<div class="form-group">
    <label>Nombre</label>
    <input type="text" id="agregar_per_nombre" class="form-control">
</div>
<div class="form-group">
    <label>Celular</label>
    <input type="text" id="agregar_per_celular" class="form-control">
</div>
<div class="form-group">
    <label>Correo</label>
    <input type="text" id="agregar_per_correo" class="form-control">
</div>
<div class="form-group">
    <label>Dirección</label>
    <input type="text" id="agregar_per_direccion" class="form-control">
</div>
<input type="hidden" id="agregar_per_ci" value="">
<input type="hidden" id="agregar_per_apellido" value="">
<input type="hidden" id="agregar_per_fenaci" value="2021-01-01">
<input type="hidden" id="agregar_id_ciu" value="1">
<input type="hidden" id="agregar_id_ec" value="1">
<input type="hidden" id="agregar_id_gen" value="1">
<?php
    }
}
if($accion == '2'){
    echo "PARA MODIFICAR";
}