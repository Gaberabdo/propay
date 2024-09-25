
# Function to remove unused packages
remove_unused_packages() {
    echo "Identifying unused packages..."

    # Get the list of currently used packages
    used_packages=$(flutter pub deps --dev | grep "├──" | awk '{print $2}' | cut -d: -f1)

    # Get the list of all packages in pubspec.yaml
    all_packages=$(grep -E '^[ ]*[^#].*:' pubspec.yaml | sed 's/:.*//g' | tail -n +2)

    echo "Used packages: $used_packages"
    echo "All packages: $all_packages"

    # Find and remove unused packages
    for package in $all_packages; do
        if [[ ! " $used_packages " =~ " $package " ]]; then
            echo "Removing unused package: $package"
            flutter pub remove $package
        fi
    done
}

# Run the function
remove_unused_packages

echo "Done!"
