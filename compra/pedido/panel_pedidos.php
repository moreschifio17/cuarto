<?php
include '../../conexion.php';
include '../../session.php';
$conexion = Conexion::conectar();
$id_suc = $_SESSION['id_suc'];
$pedidos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_compras_pedidos WHERE id_suc = $id_suc ORDER BY id_cp;"));
?>
<button class="btn btn-success" onclick="agregar();"><i class="fa fa-plus-circle"></i> Agregar</button>
<table width="100%" class="table table-bordered" id="tabla_panel_pedidos">
    <thead>
        <tr>
            <th>#</th>
            <th>Sucursal</th>
            <th>Fecha</th>
            <th>Estado</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <?php if(!empty($pedidos)){ foreach($pedidos as $p){ ?>
        <tr>
            <td><?php echo $p['id_cp'];?></td>
            <td><?php echo $p['suc_nombre'];?></td>
            <td><?php echo $p['cp_fecha_formato'];?></td>
            <td><?php echo $p['estado'];?></td>
            <td>
                <button class="btn btn-primary" onclick="datos(<?php echo $p['id_cp']; ?>);"><i class="fa fa-list-alt"></i></button>
                <?php if($p['estado'] == 'PENDIENTE'){ ?>
                <button class="btn btn-success" onclick="datos(<?php echo $p['id_cp']; ?>);"><i class="fa fa-check-circle"></i></button>
                <button class="btn btn-warning text-white" onclick="datos(<?php echo $p['id_cp']; ?>);"><i class="fa fa-edit"></i></button>
                <button class="btn btn-danger" onclick="datos(<?php echo $p['id_cp']; ?>);"><i class="fa fa-minus-circle"></i></button>
                <?php } ?>
            </td>
        </tr>
        <?php } } ?>
    </tbody>
</table>