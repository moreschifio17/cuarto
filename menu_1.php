
            <!-- MENU INICIO-->
            <aside class="main-sidebar elevation-4 sidebar-light-primary">
                <a href="/cuarto/inicio.php" class="brand-link navbar-primary">
                    <img src="/cuarto/iconos/logo.jpg" alt="LOGO" class="brand-image img-circle elevation-5">
                    <span class="brand-text text-white">CUARTO</span>
                </a>
                <div class="sidebar">
                    <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                        <div class="image" class="img-circle ejevation-2" alt="Imagen de usuario">
                            <img src="<?php echo $_SESSION['usu_imagen']; ?>" class="img-circle ejevation-2">
                        </div>
                        <div class="info">
                            <a class="d-block">
                                <?php echo $_SESSION['per_nombre']." ".$_SESSION['per_apellido'] ?>
                                <br/><span class="text-muted"><?php echo $_SESSION['usu_login']?></span>
                            </a>
                        </div>
                    </div>
                    
                    <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                        <div class="image" class="img-circle ejevation-2" alt="Imagen de sucursal">
                            <img src="<?php echo $_SESSION['suc_imagen'];?>" class="img-circle ejevation-2">
                        </div>
                        <div class="info">
                            <a class="d-block">
                                <?php echo $_SESSION['suc_nombre'];?>
                          
                            </a>
                            
                        </div>
                    </div>
                    <nav class="mt-2">
                        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                            <li class="nav-item has-treeview">
                                <a href="#" class="nav-link">
                                    <i class="nav-icon fa fa-list-alt">
                                    </i>
                                    <p>Servicio
                                        <i class="right fas fa-angle-down"></i>
                                    </p>
                                </a>
                            </li>
                                <!--Lista de pag de inicio -->
                                <ul class="nav-treeview">
                                    <li class="nav-item">
                                        <a href="/cuarto/compra/pedido" class="nav-link">
                                            <i class="fa fa-check nav-icon"></i>
                                        <p>Presupuesto</p>
                                        </a>
                                    </li>
                                </ul>
                                <!--Lista de pag de final -->
                            </li>
                            
                            <li class="nav-item has-treeview">
                                <a href="#" class="nav-link">
                                    <i class="nav-icon fa fa-list-alt">
                                    </i>
                                    <p>Compras
                                        <i class="right fas fa-angle-down"></i>
                                    </p>
                                </a>
                                
                                <!--Lista de pag de inicio -->
                                <ul class="nav-treeview">
                                    <li class="nav-item">
                                        <a href="/cuarto/compra/pedido" class="nav-link">
                                            <i class="fa fa-check nav-icon"></i>
                                        <p>Pedido compra</p>
                                        </a>
                                    </li>
                                    
                                    <li class="nav-item">
                                        <a href="/cuarto/compra/pedido" class="nav-link">
                                            <i class="fa fa-check nav-icon"></i>
                                        <p>Presupuesto compra</p>
                                        </a>
                                    </li>
                                    
                                    <li class="nav-item">
                                        <a href="/cuarto/compra/pedido" class="nav-link">
                                            <i class="fa fa-check nav-icon"></i>
                                        <p>Orden de compra</p>
                                        </a>
                                    </li>
                                    
                                </ul>
                                <!--Lista de pag de final -->
                            </li>
                            
                            <li class="nav-item has-treeview">
                                <a href="#" class="nav-link">
                                    <i class="nav-icon fa fa-list-alt">
                                    </i>
                                    <p>Facturacion
                                        <i class="right fas fa-angle-down"></i>
                                    </p>
                                </a>
                            </li>
                            
                        </ul> 
                    </nav>
                    
            </aside>