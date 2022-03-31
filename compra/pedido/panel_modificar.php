<?php
$id_cp = $_POST['id_cp'];
$id_art = $_POST['id_art'];
include '../../conexion.php';
include '../../session.php';
$datos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos_detalles WHERE id_cp = $id_cp AND id_art = $id_art;"));
?>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="card card-warning">
            <div class="card-header text-center text-white">
                Modificar Cantidad
            </div>
            <div class="card-body">
                <input type="hidden" id="modificar_id_art" value="<?php echo $datos[0]['id_art']; ?>">
                <div class="form-group">
                    <label>Producto</label>
                    <input type="text" disabled="" value="<?php echo $datos[0]['art_descrip']." - ".$datos[0]['mar_descrip']; ?>" class="form-control">
                </div>
                <div class="form-group">
                    <label>Cantidad</label>
                    <input type="number" class="form-control" value="<?php echo $datos[0]['cantidad']; ?>" id="modificar_cantidad">
                </div>
            </div>
            <div class="modal-footer justify-content-between">
                <button class="btn btn-danger" data-dismiss="modal"><i class="fa fa-ban"></i> Cancelar</button>
                <button class="btn btn-warning text-white" onclick="modificar_detalle_grabar();"><i class="fa fa-save"></i> Grabar</button>
            </div>
        </div>
    </div>
</div>