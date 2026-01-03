#!/bin/bash

# Script to backup or restore Pi-hole clients
# Usage: clients.sh [backup|restore]

CLIENTS_FILE="clients.json"
API_URL="https://pi.hole/api/clients"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    exit 1
fi

# Function to display usage
show_usage() {
    echo "Usage: $0 [backup|restore]"
    echo ""
    echo "Options:"
    echo "  backup   - Download clients from $API_URL and save to $CLIENTS_FILE"
    echo "  restore  - Read $CLIENTS_FILE and send each client back to $API_URL"
    echo ""
    echo "Examples:"
    echo "  $0 backup   # Download clients from Pi-hole API"
    echo "  $0 restore  # Upload clients to Pi-hole API"
}

# Function to backup clients
backup_clients() {
    echo "Backing up clients from $API_URL..."
    
    # Download clients from API
    if curl -k -s -o "$CLIENTS_FILE" "$API_URL"; then
        if [ -f "$CLIENTS_FILE" ] && [ -s "$CLIENTS_FILE" ]; then
            echo "Successfully downloaded clients to $CLIENTS_FILE"
            # Pretty print the JSON for readability
            jq '.' "$CLIENTS_FILE" > "${CLIENTS_FILE}.tmp" && mv "${CLIENTS_FILE}.tmp" "$CLIENTS_FILE"
        else
            echo "Error: Failed to download clients or file is empty"
            exit 1
        fi
    else
        echo "Error: Failed to connect to $API_URL"
        exit 1
    fi
}

# Function to restore clients
restore_clients() {
    # Check if clients.json exists
    if [ ! -f "$CLIENTS_FILE" ]; then
        echo "Error: $CLIENTS_FILE not found."
        echo "Run '$0 backup' first to download clients."
        exit 1
    fi

    echo "Restoring clients to $API_URL..."

    # Iterate over each client object
    jq -c '.clients[]' "$CLIENTS_FILE" | while read -r client; do
        # Remove date_added and date_modified fields
        cleaned_client=$(echo "$client" | jq 'del(.date_added, .date_modified)')
        
        # Display the client being processed
        client_id=$(echo "$cleaned_client" | jq -r '.client // .id // "unknown"')
        echo "Processing client: $client_id"
        
        clientobj=$(echo "$cleaned_client" | jq 'del(.id)')

        # Send via curl
        curl -k -X POST "$API_URL" \
            -H "Content-Type: application/json" \
            -d "$clientobj" \
            -w "\nHTTP Status: %{http_code}\n" \
            -s
        echo "---"
    done

    echo "Done processing all clients."
}

# Main script logic
case "${1:-}" in
    backup)
        backup_clients
        ;;
    restore)
        restore_clients
        ;;
    "")
        show_usage
        exit 0
        ;;
    *)
        echo "Error: Unknown argument '$1'"
        echo ""
        show_usage
        exit 1
        ;;
esac
