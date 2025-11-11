#!/bin/bash

OUTPUT="docker_service_audit.md"
echo "| Path | Container Name | Image |" > "$OUTPUT"
echo "|------|----------------|-------|" >> "$OUTPUT"

find . -type f -name "docker-compose.yml" | while read -r file; do
    dir=$(dirname "$file")

    # Grab container_name and image pairs
    awk '
    BEGIN { container=""; image="" }
    /container_name:/ { gsub(/"/, "", $2); container=$2 }
    /image:/ {
        gsub(/"/, "", $2);
        image=$2;
        if (container == "") container="(default)";
        printf "| `%s` | `%s` | `%s` |\n", FILENAME, container, image;
        container=""; image="";
    }
    ' "$file" >> "$OUTPUT"
done

echo "✅ Image + container_name audit complete: $OUTPUT"
