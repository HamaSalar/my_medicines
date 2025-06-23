<?php
require_once 'config.php';

// Initialize response variables
$response = [];
$redirect = 'medicines.php';

// Verify request method
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Check if ID is provided in the URL
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        $response = [
            'type' => 'error',
            'message' => 'No medicine ID was provided'
        ];
    } else {
        $id = trim($_GET['id']);
        
        // Validate that the ID is numeric
        if (!is_numeric($id)) {
            $response = [
                'type' => 'error',
                'message' => 'Invalid medicine ID format'
            ];
        } else {
            try {
                // Begin transaction
                $pdo->beginTransaction();
                
                // First, get the medicine name for the success message
                $stmt = $pdo->prepare("SELECT name FROM medicines WHERE id = ?");
                $stmt->execute([$id]);
                $medicine = $stmt->fetch();
                
                if (!$medicine) {
                    $response = [
                        'type' => 'error',
                        'message' => 'Medicine not found'
                    ];
                } else {
                    // Check if there are related records in the favorites table
                    $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM favorites WHERE medicine_id = ?");
                    $stmt->execute([$id]);
                    $result = $stmt->fetch();
                    
                    // If there are favorites referencing this medicine, delete them first
                    if ($result['count'] > 0) {
                        $stmt = $pdo->prepare("DELETE FROM favorites WHERE medicine_id = ?");
                        $stmt->execute([$id]);
                    }
                    
                    // Now delete the medicine
                    $stmt = $pdo->prepare("DELETE FROM medicines WHERE id = ?");
                    $result = $stmt->execute([$id]);
                    
                    if ($result) {
                        // Commit transaction
                        $pdo->commit();
                        
                        $response = [
                            'type' => 'success',
                            'message' => "Medicine '" . htmlspecialchars($medicine['name']) . "' has been deleted successfully"
                        ];
                    } else {
                        // Rollback transaction if deletion failed
                        $pdo->rollBack();
                        
                        $response = [
                            'type' => 'error',
                            'message' => 'Failed to delete medicine'
                        ];
                    }
                }
            } catch (PDOException $e) {
                // Rollback transaction in case of error
                if ($pdo->inTransaction()) {
                    $pdo->rollBack();
                }
                
                $response = [
                    'type' => 'error',
                    'message' => 'Database error: ' . $e->getMessage()
                ];
            }
        }
    }
} else {
    $response = [
        'type' => 'error',
        'message' => 'Invalid request method'
    ];
}

// Redirect with appropriate message
if (isset($response['type']) && isset($response['message'])) {
    $redirect .= '?' . $response['type'] . '=' . urlencode($response['message']);
}

header("Location: $redirect");
exit;
?>
