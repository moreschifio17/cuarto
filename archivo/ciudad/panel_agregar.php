<?php 
include '../../conexion.php';
$conexion = Conexion::conectar();
$paises = pg_fetch_all(pg_query($conexion, "SELECT * FROM paises WHERE estado = 'ACTIVO' AND id_pais != 0 ORDER BY pais_descrip;"));
?>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <label class="text-success"><i class="fa fa-plus-circle"></i> Agregar</label>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label>Descripción</label>
                <input class="form-control" type="text" id="agregar_ciudad_descrip">
            </div>
            <div class="form-group">
                <label>Pais</label>
                <select class="select2" id="agregar_id_pais">
                    <?php foreach ($paises as $p) { ?>
                        <option value="<?php echo $p['id_pais']; ?>"><?php echo $p['pais_descrip']; ?></option>
                    <?php } ?>
                </select>
            </div>

        </div>
        <div class="modal-footer justify-content-between">
            <button class="btn btn-danger" data-dismiss="modal" id="btn-cerrar-agregar"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-success" onclick="agregar_grabar();"><i class="fa fa-save"></i> Grabar</button>
        </div>
    </div>
</div>