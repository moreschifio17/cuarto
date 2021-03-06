<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Cuarto</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="/cuarto/iconos/icono.jpg" type="jpg">
        <link rel="stylesheet" href="/cuarto/estilo/dist/css/adminlte.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/font-google.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/toastr/toastr.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/select2/css/select2.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/tabla1.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/tabla2.min.css">
    </head>
    <body class="hold-transition sidebar-mini layout-fixed sidebar-collapse">
        <div class="wrapper">
            <?php 
            include '../../cabecera.php';
            include '../../menu.php';
            ?>
            <div class="content-wrapper">
                <div class="content-header">
                    <div class="container-fluid">
                        <div class="row mb-2">
                            <div class="col-sm-6">
                                <h1 class="m-0 text-dark">Referencial</h1>
                            </div>
                            <div class="col-sm-6">
                                <ol class="breadcrumb float-sm-right">
                                    <li class="breadcrumb-item active">Archivo</li>
                                    <li class="breadcrumb-item active">Paises</li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
                <section class="content">
                    <div class="card" id="panel-datos">
                        
                    </div>
                    <div class="modal fade" id="panel-agregar">

                    </div>
                    <div class="modal fade" id="panel-editar">

                    </div>
                </section>
            </div>
            <footer class="main-footer">
                <strong>Copyright &copy; 2021 <a href="#">??apu'a Solution</a></strong>
            </footer>
        </div>
        <script src="/cuarto/estilo/plugins/jquery/jquery.min.js"></script>
        <script src="/cuarto/estilo/plugins/jquery-ui/jquery-ui.min.js"></script>
        <script> $.widget.bridge('uibutton', $.ui.button) </script>
        <script src="/cuarto/estilo/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="/cuarto/estilo/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
        <script src="/cuarto/estilo/dist/js/adminlte.js"></script>
        <script src="/cuarto/iconos/fontawesome.js"></script>
        <script src="/cuarto/estilo/plugins/fastclick/fastclick.js"></script>
        <script src="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.js"></script>
        <script src="/cuarto/estilo/plugins/toastr/toastr.min.js"></script>
        <script src="/cuarto/estilo/plugins/select2/js/select2.full.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla1.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla2.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla3.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla4.min.js"></script>
    </body>
</html>