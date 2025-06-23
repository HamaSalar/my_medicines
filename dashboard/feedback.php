<?php require_once 'config.php'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback - Medicine Management System</title>
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
<style>
/* Remove arrow from DataTables length select */
div.dataTables_length select {
    -webkit-appearance: none !important;
    -moz-appearance: none !important;
    appearance: none !important;
    background-image: none !important;
    padding-right: 0.5rem !important; /* Adjust padding */
}

</style>


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
                        <a class="nav-link" href="medicines.php">
                            <i class="fas fa-pills me-1"></i> Medicines
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="feedback.php">
                            <i class="fas fa-comments me-1"></i> Feedback
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <h1 class="mb-3 mb-md-0"><i class="fas fa-comments text-primary me-2"></i>Feedback</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Feedback</li>
                        </ol>
                    </nav>
                </div>
                <hr>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-4 mb-4">
                <div class="card bg-primary text-white shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="rounded-circle bg-white p-3 me-3">
                            <i class="fas fa-comments text-primary fa-2x"></i>
                        </div>
                        <div>
                            <h3 class="mb-0">
                                <?php
                                // Get feedback count
                                $stmt = $pdo->query("SELECT COUNT(*) as count FROM feedback");
                                echo $stmt->fetch()['count'];
                                ?>
                            </h3>
                            <p class="mb-0">Total Feedback</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card bg-success text-white shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="rounded-circle bg-white p-3 me-3">
                            <i class="fas fa-calendar-alt text-success fa-2x"></i>
                        </div>
                        <div>
                            <h3 class="mb-0">
                                <?php
                                // Get feedback count for current month
                                $stmt = $pdo->query("SELECT COUNT(*) as count FROM feedback WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) AND YEAR(created_at) = YEAR(CURRENT_DATE())");
                                echo $stmt->fetch()['count'];
                                ?>
                            </h3>
                            <p class="mb-0">This Month</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card bg-info text-white shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="rounded-circle bg-white p-3 me-3">
                            <i class="fas fa-clock text-info fa-2x"></i>
                        </div>
                        <div>
                            <h3 class="mb-0">
                                <?php
                                // Get feedback count for last 7 days
                                $stmt = $pdo->query("SELECT COUNT(*) as count FROM feedback WHERE created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)");
                                echo $stmt->fetch()['count'];
                                ?>
                            </h3>
                            <p class="mb-0">Last 7 Days</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">User Feedback</h5>
                        <div>
                            <button class="btn btn-sm btn-outline-primary" id="refreshTable">
                                <i class="fas fa-sync-alt me-1"></i> Refresh
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="feedbackTable" class="table table-striped table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Message</th>
                                        <th>Timestamp</th>
                                        <th>Created At</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    // Fetch all feedback from the database
                                    $stmt = $pdo->query("SELECT * FROM feedback ORDER BY created_at DESC");
                                    
                                    while ($row = $stmt->fetch()) {
                                        echo "<tr>";
                                        echo "<td><span class='badge bg-secondary'>{$row['id']}</span></td>";
                                        echo "<td>" . htmlspecialchars($row['message']) . "</td>";
                                        echo "<td>" . date('F j, Y g:i A', strtotime($row['timestamp'])) . "</td>";
                                        echo "<td>" . date('F j, Y g:i A', strtotime($row['created_at'])) . "</td>";
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
            var table = $('#feedbackTable').DataTable({
                order: [[3, 'desc']],
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                responsive: true,
                language: {
                    search: "<i class='fas fa-search'></i> _INPUT_",
                    searchPlaceholder: "Search feedback...",
                    lengthMenu: "Show _MENU_ entries",
                    info: "Showing _START_ to _END_ of _TOTAL_ feedback entries",
                    infoEmpty: "Showing 0 to 0 of 0 feedback entries",
                    infoFiltered: "(filtered from _MAX_ total feedback entries)"
                }
            });
            
            // Refresh table data
            $('#refreshTable').on('click', function() {
                location.reload();
            });
        });
    </script>
</body>
</html>
