<?php
/**
 * @file
 * Enables modules and site configuration for a corporate site installation.
 */

use Symfony\Component\Yaml\Yaml;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Component\Utility\Environment;

/**
 * Implements hook_requirements().
 */
function corporate_requirements($phase) {
  $requirements = [];
  $phpVersion = phpversion();
  $memoryLimit = ini_get('memory_limit');
  $maxExecutionTime = ini_get('max_execution_time');

  if ($phase === "install") {
    if (version_compare($phpVersion, "8.0", "<")) {
      $requirements['php'] = [
        'title' => t('PHP'),
        'description' => t('Your PHP installation is too old. It is recommended to upgrade to PHP version <b>%php_version</b> or higher for the best ongoing support. See <a href="http://php.net/supported-versions.php">PHP\'s version support documentation</a>', ['%php_version' => "8.0"]),
        'severity' => REQUIREMENT_WARNING,
      ];
    }

    if (!Environment::checkMemoryLimit(256, $memoryLimit)) {
      $requirements['php_memory_limit'] = [
        'title' => t('PHP memory limit'),
        'description' => t('Consider increasing your PHP memory limit to <b>%memory_recommended_limit</b> M to help prevent errors in the installation process.', ['%memory_recommended_limit' => 256]),
        'severity' => REQUIREMENT_WARNING,
      ];
    }

    if ($maxExecutionTime < 180) {
      $requirements['max_execution_time'] = [
        'title' => t('Recommended maximum execution time'),
        'description' => t('Your current setting for <b>max_execution_time</b> is less than <b>%recommended_max_execution_time</b>. Change your PHP settings or contact your server administrator to set it to the recommended value.', ['%recommended_max_execution_time' => 180]),
        'severity' => REQUIREMENT_WARNING,
      ];
    }

    if (!extension_loaded('yaml')) {
      $requirements['php_yaml_extension'] = [
        'title' => 'PHP YAML extension',
        'description' => t('The PHP YAML extension is not enabled. It is recommended that you enable the PHP YAML extension for your server.'),
        'severity' => REQUIREMENT_WARNING,
      ];
    }
  }

  return $requirements;
}




