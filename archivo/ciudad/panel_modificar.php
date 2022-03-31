<?php
$id_ciudad = $_POST['id_ciudad'];
include '../../conexion.php';
$conexion = Conexion::conectar();
$datos = pg_fetch_all(pg_query($conexion,"SELECT * FROM vs_ciudades WHERE id_ciudad = $id_ciudad;"));
$paises = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_ciudades WHERE id_pais NOT IN (0, ".$datos[0]['id_pais'].");"));
?>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <label class="text-warning"><i class="fa fa-edit"></i> Modificar</label>
        </div>
        <div class="modal-body">
            <input type="hidden" id="modificar_id_ciudad" value="<?php echo $datos[0]['id_ciudad']; ?>">
            <div class="form-group">
                <label class="text-warning">Descripción</label>
                <input class="form-control" type="text" id="modificar_ciudad_descrip" value="<?php echo $datos[0]['ciu_descrip']; ?>">
            </div>
            <div class="form-group">
                <label class="text-warning">Pais</label>
                <select class="select2" id="modificar_pais_id">
                        <option value="<?php echo $datos[0]['id_pais'];?>"><?php echo $datos[0]['pais_descrip'];?></option>
                        <?php foreach($paises as $c){ ?>
                            <option value="<?php echo $c['id_pais']; ?>"><?php echo $c['pais_descrip']; ?></option>
                        <?php } ?>
                    </select>
            </div>
            
        </div>
        <div class="modal-footer justify-content-between">
            <button class="btn btn-danger" data-dismiss="modal" id="btn-cerrar-modificar"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-warning text-white" onclick="modificar_grabar();"><i class="fa fa-save"></i> Modificar</button>
        </div>
    </div>
</div>