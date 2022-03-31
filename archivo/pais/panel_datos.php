<?php
include '../../conexion.php';
$conexion = Conexion::conectar();
$datos = pg_fetch_all(pg_query($conexion, "SELECT * FROM paises ORDER BY id_pais"));
?>
<div class="card-body">
    <button type="button" class="btn btn-success" onclick="panel_agregar();">
        <i class="fa fa-plus-circle"></i> Agregar
    </button>
    <table width="100%" class="table table-bordered" id="tabla_panel_datos">
        <thead>
            <tr>
                <th>#</th>
                <th>Descripcion</th>
                <!--<th>Abreviatura</th>-->
                <th>Gentilicio</th>
                <th>Codigo</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($datos)){     foreach ($datos as $d){ ?>
            <tr>
                <td> <?php echo $d['id_pais'];?></td>
                <td> <?php echo $d['pais_descrip'];?></td>
                <!--<td> <?php //echo $d['pais_abreviatura'];?></td>-->
                <td> <?php echo $d['pais_gentilicio'];?></td>
                <td> <?php echo $d['pais_codigo'];?></td>
                <td> <?php echo $d['estado'];?></td>
                <td>
                    <?php if ($d['estado'] == 'ACTIVO'){ ?>
                    <button class="btn btn-warning text-white" title="Modificar"  onclick="panel_modificar(<?php echo $d['id_pais'];?>);">
                        <i class="fa fa-edit"></i>
                    </button>
                    <button class="btn btn-danger text-white" title="Inactivar"  onclick="inactivar_grabar(<?php echo $d['id_pais']; ?>);"><i class="fa fa-minus-circle"></i>
                    </button>
                    <?php } else { ?>
                    <button class="btn btn-success text-white" title="Activar" onclick="activar_grabar(<?php echo $d['id_pais']; ?>);"><i class="fa fa-check-circle"></i>
                    </button>
                    <?php }  ?>
                    
                </td>
            </tr>  
            
            <?php } }?>
        </tbody>
    </table>
</div>