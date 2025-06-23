<?php 
require_once 'config.php';
require_once 'auth_check.php'; // Add authentication check
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medicine Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container">
            <a class="navbar-brand" href="index.php">
                <i class="fas fa-capsules me-2"></i>Medicine Management
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.php">
                            <i class="fas fa-home me-1"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="medicines.php">
                            <i class="fas fa-pills me-1"></i> Medicines
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="feedback.php">
                            <i class="fas fa-comments me-1"></i> Feedback
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i> <?php echo htmlspecialchars($_SESSION['username']); ?>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <?php if ($_SESSION['user_role'] === 'admin'): ?>
                            <li><a class="dropdown-item" href="users.php"><i class="fas fa-users me-2"></i>Manage Users</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <?php endif; ?>
                            <li><a class="dropdown-item" href="profile.php"><i class="fas fa-user-cog me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="logout.php"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row mb-5">
            <div class="col-12">
                <div class="jumbotron bg-white p-5 rounded shadow-sm">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="display-4 mb-3">Welcome, <?php echo htmlspecialchars($_SESSION['user_name']); ?>!</h1>
                            <p class="lead mb-4">A comprehensive solution for managing medicines and tracking user feedback in a multilingual environment.</p>
                            <div class="d-flex gap-3">
                                <a href="medicines.php" class="btn btn-primary btn-lg">
                                    <i class="fas fa-pills me-2"></i>View Medicines
                                </a>
                                <a href="add_medicine.php" class="btn btn-outline-primary btn-lg">
                                    <i class="fas fa-plus-circle me-2"></i>Add New Medicine
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-4 d-none d-lg-block text-center">
                            <i class="fas fa-clinic-medical text-primary" style="font-size: 180px; opacity: 0.8;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-12">
                <h2 class="text-center mb-4">System Features</h2>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center">
                        <div class="icon-wrapper">
                            <i class="fas fa-pills"></i>
                        </div>
                        <h3 class="card-title h4 mb-3">Medicine Management</h3>
                        <p class="card-text text-muted">Add, edit, update, and delete medicines from the database with support for multiple languages.</p>
                        <a href="medicines.php" class="btn btn-primary mt-3">Manage Medicines</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center">
                        <div class="icon-wrapper">
                            <i class="fas fa-language"></i>
                        </div>
                        <h3 class="card-title h4 mb-3">Multilingual Support</h3>
                        <p class="card-text text-muted">Store and manage medicine information in multiple languages including English, Kurdish, and Arabic.</p>
                        <a href="add_medicine.php" class="btn btn-primary mt-3">Add Medicine</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center">
                        <div class="icon-wrapper">
                            <i class="fas fa-comments"></i>
                        </div>
                        <h3 class="card-title h4 mb-3">Feedback Tracking</h3>
                        <p class="card-text text-muted">View and manage user feedback in a structured format to improve medicine information.</p>
                        <a href="feedback.php" class="btn btn-primary mt-3">View Feedback</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">System Statistics</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <?php
                            // Get medicine count
                            $stmt = $pdo->query("SELECT COUNT(*) as count FROM medicines");
                            $medicine_count = $stmt->fetch()['count'];
                            
                            // Get medicine types count
                            $stmt = $pdo->query("SELECT COUNT(*) as count FROM medicine_types");
                            $type_count = $stmt->fetch()['count'];
                            
                            // Get feedback count
                            $stmt = $pdo->query("SELECT COUNT(*) as count FROM feedback");
                            $feedback_count = $stmt->fetch()['count'];
                            ?>
                            <div class="col-md-4 mb-3 mb-md-0">
                                <div class="p-4 rounded bg-light">
                                    <h3 class="text-primary mb-0"><?php echo $medicine_count; ?></h3>
                                    <p class="text-muted mb-0">Total Medicines</p>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3 mb-md-0">
                                <div class="p-4 rounded bg-light">
                                    <h3 class="text-primary mb-0"><?php echo $type_count; ?></h3>
                                    <p class="text-muted mb-0">Medicine Types</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-4 rounded bg-light">
                                    <h3 class="text-primary mb-0"><?php echo $feedback_count; ?></h3>
                                    <p class="text-muted mb-0">User Feedback</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-white py-4 mt-5">
        <div class="container text-center">
            <p class="mb-0">&copy; <?php echo date('Y'); ?> Medicine Management System. All rights reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>