<?php
$id_pais = $_POST['id_pais'];
include '../../conexion.php';
$conexion = Conexion::conectar();
$datos = pg_fetch_all(pg_query($conexion, "SELECT * FROM paises WHERE id_pais = $id_pais;"));
?>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <label class="text-warning">
                <i class="fa fa-edit"></i> Modificar 
            </label> 
        </div>
        <div class="modal-body">
            <input type="hidden" id="modificar_id_pais" value="<?php echo $datos[0]['id_pais']; ?>">
            <div class="form-group">
                <label class="text-warning">Descripcion</label> 
                <input class="form-control" required="" id="modificar_pais_descrip"  value="<?php echo $datos[0]['pais_descrip']; ?>" type="text">
            </div>
            <div class="form-group">
                <label class="text-warning">Gentilicio</label> 
                <input class="form-control" id="modificar_pais_gentilicio"  value="<?php echo $datos[0]['pais_gentilicio']; ?>" required="" type="text">
            </div>
            <div class="form-group">
                <label class="text-warning">Codigo</label> 
                <input class="form-control" id="modificar_pais_codigo" value="<?php echo $datos[0]['pais_codigo']; ?>" required="" type="text">
            </div>
            
        </div>
        <div class="modal-footer justify-content-between">
           <button class="btn btn-danger" data-dismiss="modal" id="btn-cerrar-modificar"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-warning text-white" onclick="modificar_grabar();"><i class="fa fa-save"></i> Modificar</button>
        </div>
    </div>
</div>


