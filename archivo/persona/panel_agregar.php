<?php
?>
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <label class="text-success"><i class="fa fa-plus-circle"></i> Agregar</label>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <div class="custom-control custom-switch">
                    <input onchange="agregar_persona_fisica();" type="checkbox" checked="" class="custom-control-input" id="agregar_persona_fisica">
                    <label class="custom-control-label" for="agregar_persona_fisica">Persona Física</label>
                </div>
            </div>
            <div id="panel-agregar-persona-fisica">
                
            </div>
            <script type="text/javascript">agregar_persona_fisica();</script>
        </div>
        <div class="modal-footer justify-content-between">
            <button class="btn btn-danger" data-dismiss="modal" id="btn-cerrar-agregar"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-success" onclick="agregar_grabar();"><i class="fa fa-save"></i> Grabar</button>
        </div>
    </div>
</div>