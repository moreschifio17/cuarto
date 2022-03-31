<?php
$id_cpre = $_POST['id_cpre'];
include '../../conexion.php';
include '../../session.php';
$id_suc = $_SESSION['id_suc'];
$conexion = Conexion::conectar();
if($id_cpre == '-1'){ //CUANDO SE RESETEA
    ?>
<label class="text-danger"><i class="fa fa-exclamation-circle"></i> Seleccione un pedido</label>
<?php
}else if($id_cpre == '0'){ //CUANDO SE PRESIONA EL BOTON AGREGAR
    $proveedores = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_proveedores WHERE estado = 'ACTIVO' ORDER BY per_nombre, per_apellido, per_ruc"));
?>
<div class="card card-primary">
    <div class="card-header text-center elevation-3">
        Datos del presupuesto
    </div>
    <div class="card-body">
        <input type="hidden" value="0" id="id_cpre">
        <div class="form-group">
            <label>Proveedor</label>
            <select class="select2" id="id_pro">
                <?php foreach($proveedores as $pr){ ?>
                <option value="<?php echo $pr['id_pro']; ?>"><?php echo $pr['per_nombre']." ".$pr['per_apellido']." (".$pr['per_ruc'].")"; ?></option>
                <?php } ?>
            </select>
        </div>
        <div class="form-group">
            <label>Fecha</label>
            <input type="date" value="<?php echo date('Y-m-d'); ?>" class="form-control" id="cpre_fecha">
        </div>
        <div class="form-group">
            <label>Válido Hasta</label>
            <input type="date" value="<?php echo date('Y-m-d'); ?>" class="form-control" id="cpre_validez">
        </div>
        <div class="form-group">
            <label>N° Presupuesto</label>
            <input type="number" value="123" class="form-control" id="cpre_numero">
        </div>
        <div class="form-group">
            <label>Observación</label>
            <textarea class="form-control" id="cpre_observacion"></textarea>
        </div>
        <div class="form-group">
            <button class="btn btn-danger" onclick="cancelar();"><i class="fa fa-ban"></i> Cancelar</button>
            <button class="btn btn-success" onclick="agregar_grabar();"><i class="fa fa-save"></i> Grabar</button>
        </div>
    </div>
</div>
<?php
}else{ //O SE TRATA DE UN PEDIDO DEFINIDO O SE TRATA DEL ULTIMO PEDIDO
    if($id_cpre == '-2'){ //SE TRATA DEL ULTIMO PEDIDO
        $presupuestos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_presupuestos WHERE id_cpre = (select max(id_cpre) from compras_presupuestos where id_suc = $id_suc);"));
    }else{ //SE TRATA DE UN PEDIDO DEFINIDO
        $presupuestos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_presupuestos WHERE id_cpre = $id_cpre;"));
    }
    $presupuestos_detalles = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_presupuestos_detalles WHERE id_cpre = ".$presupuestos[0]['id_cpre']." ORDER BY art_descrip, mar_descrip;"));
    $pedidos_incluidos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos WHERE id_cp IN (select id_cp from compras_presupuestos_pedidos where id_cpre = ".$presupuestos[0]['id_cpre'].");"));
    $disabled = 'disabled';
    if($presupuestos[0]['estado'] == 'PENDIENTE'){
        $disabled = '';
    }
?>
<div class="row">
    <div class="card card-primary col-12">
        <div class="card-header text-center elevation-3">
            Datos del presupuesto
        </div>
        <div class="card-body">
            <input type="hidden" value="<?php echo $presupuestos[0]['id_cpre']; ?>" id="id_cpre">
            <div class="form-group">
                <label>Proveedor</label>
                <select class="select2" id="id_pro" <?php echo $disabled; ?>>
                    <option value="<?php echo $presupuestos[0]['id_pro']; ?>"><?php echo $presupuestos[0]['per_nombre']." ".$presupuestos[0]['per_apellido']." (".$presupuestos[0]['per_ruc'].")"; ?></option>
                    <?php foreach($proveedores as $pr){ ?>
                        <option value="<?php echo $pr['id_pro']; ?>"><?php echo $pr['per_nombre']." ".$pr['per_apellido']." (".$pr['per_ruc'].")"; ?></option>
                    <?php } ?>
                </select>
            </div>
            <div class="form-group">
                <label>Fecha</label>
                <input type="date" value="<?php echo $presupuestos[0]['cpre_fecha'] ?>" class="form-control" id="cpre_fecha" <?php echo $disabled; ?>>
            </div>
            <div class="form-group">
                <label>Válido Hasta</label>
                <input type="date" value="<?php echo $presupuestos[0]['cpre_validez']; ?>" class="form-control" id="cpre_validez" <?php echo $disabled; ?>>
            </div>
            <div class="form-group">
                <label>N° Presupuesto</label>
                <input type="number" value="<?php echo $presupuestos[0]['cpre_numero']; ?>" class="form-control" id="cpre_numero" <?php echo $disabled; ?>>
            </div>
            <div class="form-group">
                <label>Observación</label>
                <textarea class="form-control" id="cpre_observacion" <?php echo $disabled; ?>><?php echo $presupuestos[0]['cpre_observacion']; ?></textarea>
            </div>
            <div class="form-group">
                <button class="btn btn-danger" onclick="cancelar();"><i class="fa fa-ban"></i> Cancelar</button>
                <?php if($presupuestos[0]['estado'] == 'PENDIENTE'){ ?>
                    <button class="btn btn-danger" onclick="anular();"><i class="fa fa-minus-circle"></i> Anular</button>
                    <button class="btn btn-warning text-white" onclick="modificar();"><i class="fa fa-edit"></i> Modificar</button>
                    <button class="btn btn-success" onclick="confirmar();"><i class="fa fa-check-circle"></i> Confirmar</button>
                <?php } ?>
            </div>
        </div>
    </div>
    <div class="card card-primary col-8">
        <div class="card-header text-center elevation-3">
            Detalles del presupuesto
        </div>
        <div class="card-body">
            <input type="hidden" id="eliminar_id_art" value="0">
            <?php if(!empty($presupuestos_detalles)){ ?>
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
                        <?php $total = 0; foreach($presupuestos_detalles as $d){ $total = $total + ($d['precio'] * $d['cantidad']); ?>
                            <tr>
                                <td><?php echo $d['art_descrip']." - ".$d['mar_descrip']; ?></td>
                                <td><?php echo $d['cantidad']; ?></td>
                                <td style="text-align: right;"><?php echo number_format($d['precio'], 0, ",", "."); ?></td>
                                <td style="text-align: right;"><?php echo number_format($d['precio'] * $d['cantidad'], 0, ",", "."); ?></td>
                                <td>
                                    <?php if($presupuestos[0]['estado'] == 'PENDIENTE'){ ?>
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
        <?php if($presupuestos[0]['estado'] == 'PENDIENTE'){
            $articulos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_articulos WHERE estado = 'ACTIVO' AND id_art NOT IN (select id_art from compras_presupuestos_detalles WHERE id_cpre = ".$presupuestos[0]['id_cpre'].") ORDER BY art_descrip;"))
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
                            <label>Precio</label>
                            <input type="number" value="1000" class="form-control" id="agregar_precio">
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
    <label class="text-primary">Pedidos incluidos</label>
    <div class="row">
        <?php if(!empty($pedidos_incluidos)){ ?>
            <?php foreach($pedidos_incluidos as $i){ ?>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>N° <?php echo $i['id_cp']; ?></th>
                            <th colspan="4"><?php echo $i['cp_fecha_formato']; ?></th>
                        </tr>
                        <tr>
                            <th>Producto</th>
                            <th>Cantidad</th>
                            <th>Precio</th>
                            <th>Subtotal</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $pedidos_detalles = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_presupuestos_pedidos WHERE id_cpre = ".$presupuestos[0]['id_cpre']." and id_cp = ".$i['id_cp'])); ?>
                        <?php $total = 0; foreach($pedidos_detalles as $d){ $total = $total + ($d['precio'] * $d['cantidad']); ?>
                            <tr>
                                <td><?php echo $d['art_descrip']." - ".$d['mar_descrip']; ?></td>
                                <td><?php echo $d['cantidad']; ?></td>
                                <td><?php echo $d['precio']; ?></td>
                                <td><?php echo $d['precio'] * $d['cantidad']; ?></td>
                                <td>
                                    <button class="btn btn-warning text-white"><i class="fa fa-edit"></i></button>
                                    <button class="btn btn-danger"><i class="fa fa-minus-circle"></i></button>
                                </td>
                            </tr>
                        <?php }  ?>
                        <?php $pedidos_detalles_excluidos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos_detalles WHERE id_cp = ".$i['id_cp']." and id_art not in (select id_art from compras_presupuestos_pedidos where id_cp = ".$i['id_cp']." and id_cpre = ".$presupuestos[0]['id_cpre'].")")); ?>
                            <?php if(!empty($pedidos_detalles_excluidos)){ foreach($pedidos_detalles_excluidos as $e){ ?>
                            <tr>
                                <td><?php echo $e['art_descrip']." - ".$e['mar_descrip']; ?></td>
                                <td><?php echo $e['cantidad']; ?></td>
                                <td><?php echo $e['precio']; ?></td>
                                <td><?php echo $e['precio'] * $e['cantidad']; ?></td>
                                <td>
                                    <button class="btn btn-success"><i class="fa fa-plus-circle"></i></button>
                                </td>
                            </tr>
                            <?php } } ?>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="3">Total</th>
                            <th colspan="2"><?php echo $total; ?></th>
                        </tr>
                    </tfoot>
                </table>
            <?php } ?>
        <?php }else{ ?>
        <label class="text-danger"><i class="fa fa-exclamation-circle"></i> No se incluyeron pedidos</label>
        <?php } ?>
    </div>
    <?php if($presupuestos[0]['estado'] == 'PENDIENTE'){
        $pedidos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos WHERE id_suc = $id_suc and estado = 'CONFIRMADO' and id_cp NOT IN (select id_cp from compras_presupuestos_pedidos WHERE id_cpre = ".$presupuestos[0]['id_cpre'].");"));
        ?>
    <br>
    <label class="text-primary">Agregar Pedido</label>
    <div class="row">
        <input type="hidden" value="0" id="agregar_id_cp">
        <?php if(!empty($pedidos)){ foreach($pedidos as $ped){ ?>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>N° <?php echo $ped['id_cp']; ?></th>
                    <th colspan="2"><?php echo $ped['cp_fecha_formato']; ?></th>
                    <th><button class="btn btn-success" onclick="agregar_pedido(<?php echo $ped['id_cp']; ?>);"><i class="fa fa-plus-circle"></i></button></th>
                </tr>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <?php $pedidos_detalles = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos_detalles WHERE id_cp = ".$ped['id_cp'])); ?>
                <?php $total = 0; foreach($pedidos_detalles as $d){ $total = $total + ($d['precio'] * $d['cantidad']); ?>
                    <tr>
                        <td><?php echo $d['art_descrip']." - ".$d['mar_descrip']; ?></td>
                        <td><?php echo $d['cantidad']; ?></td>
                        <td><?php echo $d['precio']; ?></td>
                        <td><?php echo $d['precio'] * $d['cantidad']; ?></td>
                    </tr>
                <?php }  ?>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3">Total</th>
                    <th><?php echo $total; ?></th>
                </tr>
            </tfoot>
        </table>
        <?php } }else{ ?>
        <label class="text-danger"><i class="fa fa-exclamation-circle"></i> No se registran pedidos disponibles</label>
        <?php } ?>
    </div>
    <?php } ?>
<?php
}
