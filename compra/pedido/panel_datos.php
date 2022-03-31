<?php
$id_cp = $_POST['id_cp'];
include '../../conexion.php';
include '../../session.php';
$id_suc = $_SESSION['id_suc'];
$conexion = Conexion::conectar();
if($id_cp == '-1'){ //CUANDO SE RESETEA
    ?>
<label class="text-danger"><i class="fa fa-exclamation-circle"></i> Seleccione un pedido</label>
<?php
}else if($id_cp == '0'){ //CUANDO SE PRESIONA EL BOTON AGREGAR
?>
<div class="card card-primary">
    <div class="card-header text-center elevation-3">
        Datos del pedido
    </div>
    <div class="card-body">
        <input type="hidden" value="0" id="id_cp">
        <div class="form-group">
            <label>Fecha</label>
            <input type="date" value="<?php echo date('Y-m-d'); ?>" class="form-control" id="cp_fecha">
        </div>
        <div class="form-group">
            <button class="btn btn-danger" onclick="cancelar();"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-success" onclick="agregar_grabar();"><i class="fa fa-save"></i> Grabar</button>
        </div>
    </div>
</div>
<?php
}else{ //O SE TRATA DE UN PEDIDO DEFINIDO O SE TRATA DEL ULTIMO PEDIDO
    if($id_cp == '-2'){ //SE TRATA DEL ULTIMO PEDIDO
        $pedidos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos WHERE id_cp = (select max(id_cp) from compras_pedidos where id_suc = $id_suc);"));
    }else{ //SE TRATA DE UN PEDIDO DEFINIDO
        $pedidos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos WHERE id_cp = $id_cp;"));
    }
    $pedidos_detalles = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos_detalles WHERE id_cp = ".$pedidos[0]['id_cp']." ORDER BY art_descrip, mar_descrip;"));
    $disabled = 'disabled';
    if($pedidos[0]['estado'] == 'PENDIENTE'){
        $disabled = '';
    }
?>
<div class="row">
    <div class="card card-primary col-12">
        <div class="card-header text-center elevation-3">
            Datos del pedido
        </div>
        <div class="card-body">
            <input type="hidden" value="<?php echo $pedidos[0]['id_cp']; ?>" id="id_cp">
            <input type="hidden" value="0" id="eliminar_id_art">
            <div class="form-group">
                <label>Fecha</label>
                <input type="date" value="<?php echo $pedidos[0]['cp_fecha']; ?>" <?php echo $disabled; ?> class="form-control" id="cp_fecha">
            </div>
            <div class="form-group">
                <button class="btn btn-danger" onclick="cancelar();"><i class="fa fa-ban"></i> Cancelar</button>
                <?php if($pedidos[0]['estado'] == 'PENDIENTE'){ ?>
                    <button class="btn btn-danger" onclick="anular();"><i class="fa fa-minus-circle"></i> Anular</button>
                    <button class="btn btn-warning text-white" onclick="modificar();"><i class="fa fa-edit"></i> Modificar</button>
                    <button class="btn btn-success" onclick="confirmar();"><i class="fa fa-check-circle"></i> Confirmar</button>
                <?php } ?>
            </div>
        </div>
    </div>
    <div class="card card-primary col-8">
        <div class="card-header text-center elevation-3">
            Detalles del pedido
        </div>
        <div class="card-body">
            <?php if(!empty($pedidos_detalles)){ ?>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Producto</th>
                            <th>Cantidad</th>
                            <th>Precio</th>
                            <th>Subtotal</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $total = 0; foreach($pedidos_detalles as $d){ $total = $total + ($d['precio'] * $d['cantidad']); ?>
                            <tr>
                                <td><?php echo $d['art_descrip']." - ".$d['mar_descrip']; ?></td>
                                <td><?php echo $d['cantidad']; ?></td>
                                <td style="text-align: right;"><?php echo number_format($d['precio'], 0, ",", "."); ?></td>
                                <td style="text-align: right;"><?php echo number_format($d['precio'] * $d['cantidad'], 0, ",", "."); ?></td>
                                <td>
                                    <?php if($pedidos[0]['estado'] == 'PENDIENTE'){ ?>
                                        <button class="btn btn-warning text-white" onclick="modificar_detalle(<?php echo $d['id_art']; ?>);" id="btn-panel-modificar-cerrar"><i class="fa fa-edit"></i></button>
                                        <button class="btn btn-danger" onclick="eliminar_detalle(<?php echo $d['id_art']; ?>);"><i class="fa fa-minus-circle"></i></button>
                                    <?php } ?>
                                </td>
                            </tr>
                        <?php } ?>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="3">Total</th>
                            <th style="text-align: right;">Gs. <?php echo number_format($total, 0, ",", "."); ?></th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            <?php }else{ ?>
                <label class="text-danger"><i class="fa fa-exclamation-circle"></i> No se registraron detalles...</label>
            <?php } ?>
        </div>
    </div>
        <?php if($pedidos[0]['estado'] == 'PENDIENTE'){
            $articulos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_articulos WHERE estado = 'ACTIVO' AND id_art NOT IN (select id_art from compras_pedidos_detalles WHERE id_cp = ".$pedidos[0]['id_cp'].") ORDER BY art_descrip;"))
            ?>
            <div class="card card-primary col-4">
                <div class="card-header text-center elevation-3">
                    Agregar Producto
                </div>
                <div class="card-body">
                    <?php if(!empty($articulos)){ ?>
                        <div class="form-group">
                            <label>Producto</label>
                            <select class="select2" id="agregar_id_art">
                                <?php foreach($articulos as $a){ ?>
                                <option value="<?php echo $a['id_art']; ?>"><?php echo $a['art_descrip']." - ".$a['mar_descrip']; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Cantidad</label>
                            <input type="number" value="1" class="form-control" id="agregar_cantidad">
                        </div>
                        <div class="form-group">
                            <button class="btn btn-success" onclick="agregar_detalles();"><i class="fa fa-plus-circle"></i> Agregar</button>
                        </div>
                    <?php }else{ ?>
                        <label class="text-danger"><i class="fa fa-exclamation-circle"></i> No se encuentran productos disponibles...</label>
                    <?php } ?>
                </div>
            </div>
        <?php } ?>
    </div>
<?php
}
