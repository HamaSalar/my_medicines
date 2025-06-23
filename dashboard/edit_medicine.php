<?php 
require_once 'config.php';

// Check if ID is provided
if (!isset($_GET['id']) || empty($_GET['id'])) {
    // Redirect to medicines page if ID is not provided
    header("Location: medicines.php");
    exit;
}

$id = $_GET['id'];

// Initialize variables
$name = $description = $description1 = $description2 = $dosage = $dosage1 = $dosage2 = '';
$type_id = 0;
$other_names = $uses = $uses1 = $uses2 = $type_name = '';

// Check if the form was submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve form data
    $name = $_POST['name'] ?? '';
    $description = $_POST['description'] ?? '';
    $description1 = $_POST['description1'] ?? '';
    $description2 = $_POST['description2'] ?? '';
    $dosage = $_POST['dosage'] ?? '';
    $dosage1 = $_POST['dosage1'] ?? '';
    $dosage2 = $_POST['dosage2'] ?? '';
    $type_id = $_POST['type_id'] ?? 0;
    $other_names = $_POST['other_names'] ?? '';
    $uses = $_POST['uses'] ?? '';
    $uses1 = $_POST['uses1'] ?? '';
    $uses2 = $_POST['uses2'] ?? '';
    $type_name = $_POST['type_name'] ?? '';
    
    // Validate form data (basic validation)
    $errors = [];
    
    if (empty($name)) {
        $errors[] = "Name is required";
    }
    
    if (empty($description)) {
        $errors[] = "Description is required";
    }
    
    if (empty($type_id)) {
        $errors[] = "Type is required";
    }
    
    // If there are no errors, update the data in the database
    if (empty($errors)) {
        try {
            $sql = "UPDATE medicines 
                   SET name = ?, description = ?, description1 = ?, description2 = ?, 
                       dosage = ?, dosage1 = ?, dosage2 = ?, type_id = ?, 
                       other_names = ?, uses = ?, uses1 = ?, uses2 = ?, type_name = ?,
                       updated_at = CURRENT_TIMESTAMP
                   WHERE id = ?";
            
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                $name, $description, $description1, $description2, $dosage, $dosage1, $dosage2, 
                $type_id, $other_names, $uses, $uses1, $uses2, $type_name, $id
            ]);
            
            // Set success message
            $success = "Medicine updated successfully!";
        } catch (PDOException $e) {
            $errors[] = "Database error: " . $e->getMessage();
        }
    }
} else {
    // Fetch medicine data for editing
    try {
        $stmt = $pdo->prepare("SELECT * FROM medicines WHERE id = ?");
        $stmt->execute([$id]);
        $medicine = $stmt->fetch();
        
        if (!$medicine) {
            // If medicine with the given ID doesn't exist, redirect to medicines page
            header("Location: medicines.php");
            exit;
        }
        
        // Populate variables with the fetched data
        $name = $medicine['name'];
        $description = $medicine['description'];
        $description1 = $medicine['description1'];
        $description2 = $medicine['description2'];
        $dosage = $medicine['dosage'];
        $dosage1 = $medicine['dosage1'];
        $dosage2 = $medicine['dosage2'];
        $type_id = $medicine['type_id'];
        $other_names = $medicine['other_names'];
        $uses = $medicine['uses'];
        $uses1 = $medicine['uses1'];
        $uses2 = $medicine['uses2'];
        $type_name = $medicine['type_name'];
    } catch (PDOException $e) {
        $errors[] = "Database error: " . $e->getMessage();
    }
}

// Fetch medicine types for dropdown
$stmt = $pdo->query("SELECT * FROM medicine_types ORDER BY name");
$medicine_types = $stmt->fetchAll();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Medicine - Medicine Management System</title>
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
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <h1 class="mb-3 mb-md-0"><i class="fas fa-edit text-primary me-2"></i>Edit Medicine</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                            <li class="breadcrumb-item"><a href="medicines.php">Medicines</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Edit Medicine</li>
                        </ol>
                    </nav>
                </div>
                <hr>
            </div>
        </div>

        <?php if (!empty($errors)): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong><i class="fas fa-exclamation-triangle me-2"></i>Error!</strong>
                <ul class="mb-0 ps-3">
                    <?php foreach ($errors as $error): ?>
                        <li><?php echo $error; ?></li>
                    <?php endforeach; ?>
                </ul>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <?php endif; ?>

        <?php if (isset($success)): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong><i class="fas fa-check-circle me-2"></i>Success!</strong> <?php echo $success; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <?php endif; ?>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Edit Medicine: <?php echo htmlspecialchars($name); ?></h5>
                        <span class="badge bg-primary">ID: <?php echo $id; ?></span>
                    </div>
                    <div class="card-body">
                        <form action="edit_medicine.php?id=<?php echo $id; ?>" method="post">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label for="name" class="form-label">Medicine Name <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-prescription-bottle-medical"></i></span>
                                        <input type="text" class="form-control" id="name" name="name" value="<?php echo htmlspecialchars($name); ?>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="type_id" class="form-label">Medicine Type <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-tag"></i></span>
                                        <select class="form-select" id="type_id" name="type_id" required>
                                            <option value="">Select Type</option>
                                            <?php foreach ($medicine_types as $type): ?>
                                                <option value="<?php echo $type['id']; ?>" <?php echo $type_id == $type['id'] ? 'selected' : ''; ?>>
                                                    <?php echo htmlspecialchars($type['name']); ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <label for="type_name" class="form-label">Type Name (Optional)</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-tag"></i></span>
                                        <input type="text" class="form-control" id="type_name" name="type_name" value="<?php echo htmlspecialchars($type_name); ?>">
                                    </div>
                                    <div class="form-text">Specify a custom type name if needed</div>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <label for="other_names" class="form-label">Other Names</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-signature"></i></span>
                                        <input type="text" class="form-control" id="other_names" name="other_names" value="<?php echo htmlspecialchars($other_names); ?>">
                                    </div>
                                    <div class="form-text">Enter alternative names separated by commas</div>
                                </div>
                            </div>

                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">Description</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label for="description" class="form-label">Description (English) <span class="text-danger">*</span></label>
                                            <textarea class="form-control" id="description" name="description" rows="3" required><?php echo htmlspecialchars($description); ?></textarea>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3 mb-md-0">
                                            <label for="description1" class="form-label">Description (Kurdish)</label>
                                            <textarea class="form-control" id="description1" name="description1" rows="3" dir="rtl"><?php echo htmlspecialchars($description1); ?></textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="description2" class="form-label">Description (Arabic)</label>
                                            <textarea class="form-control" id="description2" name="description2" rows="3" dir="rtl"><?php echo htmlspecialchars($description2); ?></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">Dosage Information</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label for="dosage" class="form-label">Dosage (English)</label>
                                            <textarea class="form-control" id="dosage" name="dosage" rows="2"><?php echo htmlspecialchars($dosage); ?></textarea>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3 mb-md-0">
                                            <label for="dosage1" class="form-label">Dosage (Kurdish)</label>
                                            <textarea class="form-control" id="dosage1" name="dosage1" rows="2" dir="rtl"><?php echo htmlspecialchars($dosage1); ?></textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="dosage2" class="form-label">Dosage (Arabic)</label>
                                            <textarea class="form-control" id="dosage2" name="dosage2" rows="2" dir="rtl"><?php echo htmlspecialchars($dosage2); ?></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">Uses</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label for="uses" class="form-label">Uses (English)</label>
                                            <textarea class="form-control" id="uses" name="uses" rows="2"><?php echo htmlspecialchars($uses); ?></textarea>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3 mb-md-0">
                                            <label for="uses1" class="form-label">Uses (Kurdish)</label>
                                            <textarea class="form-control" id="uses1" name="uses1" rows="2" dir="rtl"><?php echo htmlspecialchars($uses1); ?></textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="uses2" class="form-label">Uses (Arabic)</label>
                                            <textarea class="form-control" id="uses2" name="uses2" rows="2" dir="rtl"><?php echo htmlspecialchars($uses2); ?></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-12 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-1"></i> Update Medicine
                                    </button>
                                    <a href="medicines.php" class="btn btn-outline-secondary">
                                        <i class="fas fa-times me-1"></i> Cancel
                                    </a>
                                </div>
                            </div>
                        </form>
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
