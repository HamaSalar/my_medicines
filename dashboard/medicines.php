<?php 
require_once 'config.php';
require_once 'auth_check.php'; // Add authentication check
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medicines - Medicine Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
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
                        <a class="nav-link" href="index.php">
                            <i class="fas fa-home me-1"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="medicines.php">
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
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <h1 class="mb-3 mb-md-0"><i class="fas fa-pills text-primary me-2"></i>Medicines</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Medicines</li>
                        </ol>
                    </nav>
                </div>
                <hr>
            </div>
        </div>

        <?php
        // Handle success and error messages
        if (isset($_GET['success'])) {
            echo '<div class="alert alert-success alert-dismissible fade show" role="alert">
                  <strong>Success!</strong> ' . htmlspecialchars($_GET['success']) . '
                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                  </div>';
        }
        
        if (isset($_GET['error'])) {
            echo '<div class="alert alert-danger alert-dismissible fade show" role="alert">
                  <strong>Error!</strong> ' . htmlspecialchars($_GET['error']) . '
                  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                  </div>';
        }
        ?>

        <div class="row mb-4">
            <div class="col-12 d-flex justify-content-between align-items-center flex-wrap">
                <a href="add_medicine.php" class="btn btn-success mb-2 mb-md-0">
                    <i class="fas fa-plus-circle me-1"></i> Add New Medicine
                </a>
                
                <div class="d-flex gap-2">
                    <div class="dropdown">
                        <button class="btn btn-outline-primary dropdown-toggle" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-filter me-1"></i> Filter
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                            <li><a class="dropdown-item" href="medicines.php">All Medicines</a></li>
                            <?php
                            // Fetch medicine types for filter dropdown
                            $stmt = $pdo->query("SELECT * FROM medicine_types ORDER BY name");
                            while ($type = $stmt->fetch()) {
                                echo '<li><a class="dropdown-item" href="medicines.php?type=' . $type['id'] . '">' . htmlspecialchars($type['name']) . '</a></li>';
                            }
                            ?>
                        </ul>
                    </div>
                    
                    <a href="medicines.php" class="btn btn-outline-secondary">
                        <i class="fas fa-sync-alt me-1"></i> Refresh
                    </a>
                </div>
            </div>
        </div>

        <?php
        // Handle delete request
        if (isset($_GET['delete_id']) && !empty($_GET['delete_id'])) {
            $delete_id = $_GET['delete_id'];
            
            try {
                $stmt = $pdo->prepare("DELETE FROM medicines WHERE id = ?");
                $stmt->execute([$delete_id]);
                echo '<div class="alert alert-success alert-dismissible fade show" role="alert">
                      <strong>Success!</strong> Medicine has been deleted successfully.
                      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                      </div>';
            } catch (PDOException $e) {
                echo '<div class="alert alert-danger alert-dismissible fade show" role="alert">
                      <strong>Error!</strong> Could not delete medicine: ' . $e->getMessage() . '
                      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                      </div>';
            }
        }
        ?>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Medicine List</h5>
                        <span class="badge bg-primary">
                            <?php
                            // Get medicine count
                            $stmt = $pdo->query("SELECT COUNT(*) as count FROM medicines");
                            echo $stmt->fetch()['count'] . ' Medicines';
                            ?>
                        </span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="medicinesTable" class="table table-striped table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Type</th>
                                        <th>Dosage</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    // Prepare the query based on filter
                                    $query = "SELECT m.*, mt.name as type_name 
                                             FROM medicines m 
                                             LEFT JOIN medicine_types mt ON m.type_id = mt.id";
                                    
                                    // Add type filter if specified
                                    if (isset($_GET['type']) && !empty($_GET['type'])) {
                                        $type_id = $_GET['type'];
                                        $query .= " WHERE m.type_id = " . intval($type_id);
                                    }
                                    
                                    $query .= " ORDER BY m.id DESC";
                                    $stmt = $pdo->query($query);
                                    
                                    while ($row = $stmt->fetch()) {
                                        echo "<tr>";
                                        echo "<td>{$row['id']}</td>";
                                        echo "<td><strong>{$row['name']}</strong>";
                                        
                                        // Show other names if available
                                        if (!empty($row['other_names'])) {
                                            echo "<br><small class='text-muted'>Also: " . htmlspecialchars($row['other_names']) . "</small>";
                                        }
                                        
                                        echo "</td>";
                                        echo "<td><span class='badge bg-light text-dark'>{$row['type_name']}</span></td>";
                                        echo "<td>" . (strlen($row['dosage']) > 50 ? substr(htmlspecialchars($row['dosage']), 0, 50) . "..." : htmlspecialchars($row['dosage'])) . "</td>";
                                        echo "<td>" . date('M j, Y', strtotime($row['created_at'])) . "</td>";
                                        echo "<td>
                                                <div class='d-flex gap-1'>
                                                    <a href='edit_medicine.php?id={$row['id']}' class='btn btn-sm btn-primary'>
                                                        <i class='fas fa-edit me-1'></i> Edit
                                                    </a>
                                                    <button class='btn btn-sm btn-danger' data-bs-toggle='modal' data-bs-target='#deleteModal{$row['id']}'>
                                                        <i class='fas fa-trash'></i>
                                                    </button>
                                                </div>
                                                
                                                <!-- Delete Confirmation Modal -->
                                                <div class='modal fade' id='deleteModal{$row['id']}' tabindex='-1' aria-hidden='true'>
                                                    <div class='modal-dialog'>
                                                        <div class='modal-content'>
                                                            <div class='modal-header'>
                                                                <h5 class='modal-title'>Confirm Delete</h5>
                                                                <button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>
                                                            </div>
                                                            <div class='modal-body'>
                                                                <p>Are you sure you want to delete the medicine <strong>{$row['name']}</strong>?</p>
                                                                <p class='text-danger'><small><i class='fas fa-exclamation-triangle me-1'></i> This action cannot be undone.</small></p>
                                                            </div>
                                                            <div class='modal-footer'>
                                                                <button type='button' class='btn btn-outline-secondary' data-bs-dismiss='modal'>Cancel</button>
                                                                <a href='delete_medicine.php?id={$row['id']}' class='btn btn-danger'>Delete</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                              </td>";
                                        echo "</tr>";
                                    }
                                    ?>
                                </tbody>
                            </table>
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

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#medicinesTable').DataTable({
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                responsive: true,
                language: {
                    search: "<i class='fas fa-search'></i> _INPUT_",
                    searchPlaceholder: "Search medicines...",
                    lengthMenu: "Show _MENU_ entries",
                    info: "Showing _START_ to _END_ of _TOTAL_ medicines",
                    infoEmpty: "Showing 0 to 0 of 0 medicines",
                    infoFiltered: "(filtered from _MAX_ total medicines)"
                }
            });
        });
    </script>
</body>
</html>
