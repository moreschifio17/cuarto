<?php
include '../../conexion.php';
$conexion = Conexion::conectar();
$datos = pg_fetch_all(pg_query($conexion, "SELECT * FROM vs_ciudades ORDER BY id_ciudad;"));
?>
<div class="card-body">
    <button type="button" class="btn btn-success" onclick="panel_agregar();"><i class="fa fa-plus-circle"></i> Agregar</button>
    <table width="100%" class="table table-bordered" id="tabla_panel_datos">
        <thead>
            <tr>
                <th>#</th>
                <th>Descripción</th>
                <th>Pais</th>
                <!--<th>Código</th>-->
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php if(!empty($datos)){ foreach($datos as $d){ ?>
                <tr>
                    <td><?php echo $d['id_ciudad']; ?></td>
                    <td><?php echo $d['ciu_descrip']; ?></td>
                    <td><?php echo $d['pais_descrip']; ?></td>
                    <td><?php echo $d['estado']; ?></td>
                    <td>
                        <?php if($d['estado'] == 'ACTIVO'){ ?>
                            <button class="btn btn-warning text-white" onclick="panel_modificar(<?php echo $d['id_ciudad']; ?>);"><i class="fa fa-edit"></i></button>
                            <button class="btn btn-danger" onclick="inactivar_grabar(<?php echo $d['id_ciudad']; ?>);"><i class="fa fa-minus-circle"></i></button>
                        <?php }else{ ?>
                            <button class="btn btn-success" onclick="activar_grabar(<?php echo $d['id_ciudad']; ?>);"><i class="fa fa-check-circle"></i></button>
                        <?php } ?>
                    </td>
                </tr>
            <?php } } ?>
        </tbody>
    </table>
</div>