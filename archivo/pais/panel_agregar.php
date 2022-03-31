<?php 
?>

<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <label class="text-success">
                <i class="fa fa-plus-circle"></i> Agregar 
            </label> 
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label class="text-dark">Descripcion</label> 
                <input class="form-control" id="agregar_pais_descrip" required="" type="text" autofocus="">
            </div>
            <div class="form-group">
                <label class="text-dark">Gentilicio</label> 
                <input class="form-control" id="agregar_pais_gentilicio" required="" type="text">
            </div>
            <div class="form-group">
                <label class="text-dark">Codigo</label> 
                <input class="form-control" id="agregar_pais_codigo" required="" type="text">
            </div>
            
        </div>
        <div class="modal-footer justify-content-between">
           <button class="btn btn-danger" data-dismiss="modal" id="btn-cerrar-agregar"><i class="fa fa-ban"></i> Cancelar</button>
           <button class="btn btn-success" onclick="agregar_grabar();"><i class="fa fa-save"></i> Grabar</button>
        </div>
    </div>
</div>


