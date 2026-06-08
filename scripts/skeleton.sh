#!/bin/bash
# create barrel exports and .gitkeep for every feature leaf folder

features=(server_config subscription feed groups publish notifications settings)

for feature in "${features[@]}"; do
  # Create barrel file
  echo "// ${feature} feature exports" > "lib/features/${feature}/${feature}.dart"
done

# Core barrel files
echo "// core exports" > lib/core/core.dart
echo "// shared exports" > lib/shared/shared.dart

# .gitkeep for empty leaf folders that have no files yet
leaf_dirs=(
  "lib/core/error"
  "lib/core/network"
  "lib/core/secure_storage"
  "lib/core/app_lock"
  "lib/core/usecase"
  "lib/core/utils"
  "lib/core/database"
)

for dir in "${leaf_dirs[@]}"; do
  mkdir -p "$dir"
  touch "$dir/.gitkeep"
done

echo "folder skeleton complete"