<?php
$id_per = $_POST['id_per'];
include '../../conexion.php';
$conexion = Conexion::conectar();
$datos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_personas WHERE id_per = $id_per;"));
$ciudades = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_ciudades WHERE id_ciu NOT IN (0, ".$datos[0]['id_ciu'].");"));
$estados_civiles = pg_fetch_all(pg_query($conexion, "SELECT * FROM estados_civiles WHERE id_ec NOT IN (0, ".$datos[0]['id_ec'].");"));
$generos = pg_fetch_all(pg_query($conexion, "SELECT * FROM generos WHERE id_gen NOT IN (0, ".$datos[0]['id_gen'].");"));
?>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <label class="text-warning"><i class="fa fa-edit"></i> Modificar</label>
        </div>
        <div class="modal-body">
            <input type="hidden" id="modificar_id_per" value="<?php echo $datos[0]['id_per']; ?>">
            <?php if($datos[0]['per_fisica'] == 't'){ ?>
                <div class="form-group">
                    <div class="custom-control custom-switch">
                        <input type="checkbox" <?php if($datos[0]['per_fisica'] == 't'){ echo "checked"; } ?> class="custom-control-input" disabled="">
                        <label class="custom-control-label" for="modificar_persona_fisica">Persona Física</label>
                    </div>
                </div>
                <div class="form-group">
                    <label>C.I.</label>
                    <input type="text" id="modificar_per_ci" class="form-control" value="<?php echo $datos[0]['per_ci']; ?>">
                </div>
                <div class="form-group">
                    <label>R.U.C.</label>
                    <input type="text" id="modificar_per_ruc" class="form-control" value="<?php echo $datos[0]['per_ruc']; ?>">
                </div>
                <div class="form-group">
                    <label>Nombre</label>
                    <input type="text" id="modificar_per_nombre" class="form-control" value="<?php echo $datos[0]['per_nombre']; ?>">
                </div>
                <div class="form-group">
                    <label>Apellido</label>
                    <input type="text" id="modificar_per_apellido" class="form-control" value="<?php echo $datos[0]['per_apellido']; ?>">
                </div>
                <div class="form-group">
                    <label>Fecha de Nacimiento</label>
                    <input type="date" id="modificar_per_fenaci" class="form-control" value="<?php echo $datos[0]['per_fenaci']; ?>">
                </div>
                <div class="form-group">
                    <label>Celular</label>
                    <input type="text" id="modificar_per_celular" class="form-control" value="<?php echo $datos[0]['per_celular']; ?>">
                </div>
                <div class="form-group">
                    <label>Correo</label>
                    <input type="text" id="modificar_per_correo" class="form-control" value="<?php echo $datos[0]['per_correo']; ?>">
                </div>
                <div class="form-group">
                    <label>Dirección</label>
                    <input type="text" id="modificar_per_direccion" class="form-control" value="<?php echo $datos[0]['per_direccion']; ?>">
                </div>
                <div class="form-group">
                    <label>Ciudad de Nacimiento</label>
                    <select class="select2" id="modificar_id_ciu">
                        <option value="<?php echo $datos[0]['id_ciu'];?>"><?php echo $datos[0]['ciu_descrip']." - ".$datos[0]['pais_descrip'];?></option>
                        <?php foreach($ciudades as $c){ ?>
                            <option value="<?php echo $c['id_ciu']; ?>"><?php echo $c['ciu_descrip']." - ".$c['pais_descrip']; ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Estado Civil</label>
                    <select class="select2" id="modificar_id_ec">
                        <option value="<?php echo $datos[0]['id_ec'];?>"><?php echo $datos[0]['ec_descrip'];?></option>
                        <?php foreach($estados_civiles as $e){ ?>
                            <option value="<?php echo $e['id_ec']; ?>"><?php echo $e['ec_descrip']; ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Género</label>
                    <select class="select2" id="modificar_id_gen">
                        <option value="<?php echo $datos[0]['id_gen'];?>"><?php echo $datos[0]['gen_descrip'];?></option>
                        <?php foreach($generos as $g){ ?>
                            <option value="<?php echo $g['id_gen']; ?>"><?php echo $g['gen_descrip']; ?></option>
                        <?php } ?>
                    </select>
                </div>
            <?php }else{ ?>
                <div class="form-group">
                    <div class="custom-control custom-switch">
                        <input type="checkbox" class="custom-control-input" disabled="">
                        <label class="custom-control-label" for="modificar_persona_fisica">Persona Jurídica</label>
                    </div>
                </div>
                <div class="form-group">
                    <label>R.U.C.</label>
                    <input type="text" id="modificar_per_ruc" class="form-control" value="<?php echo $datos[0]['per_ruc']; ?>">
                </div>
                <div class="form-group">
                    <label>Nombre</label>
                    <input type="text" id="modificar_per_nombre" class="form-control" value="<?php echo $datos[0]['per_nombre']; ?>">
                </div>
                <div class="form-group">
                    <label>Celular</label>
                    <input type="text" id="modificar_per_celular" class="form-control" value="<?php echo $datos[0]['per_celular']; ?>">
                </div>
                <div class="form-group">
                    <label>Correo</label>
                    <input type="text" id="modificar_per_correo" class="form-control" value="<?php echo $datos[0]['per_correo']; ?>">
                </div>
                <div class="form-group">
                    <label>Dirección</label>
                    <input type="text" id="modificar_per_direccion" class="form-control" value="<?php echo $datos[0]['per_direccion']; ?>">
                </div>
                <input type="hidden" id="modificar_per_ci" value="">
                <input type="hidden" id="modificar_per_apellido" value="">
                <input type="hidden" id="modificar_per_fenaci" value="2021-01-01">
                <input type="hidden" id="modificar_id_ciu" value="0">
                <input type="hidden" id="modificar_id_ec" value="0">
                <input type="hidden" id="modificar_id_gen" value="0">
            <?php } ?>
        </div>
        <div class="modal-footer justify-content-between">
            <button class="btn btn-danger" data-dismiss="modal" id="btn-cerrar-modificar"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-warning text-white" onclick="modificar_grabar();"><i class="fa fa-save"></i> Grabar</button>
        </div>
    </div>
</div>