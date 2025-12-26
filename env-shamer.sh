#!/bin/bash
# ENV Var Shamer - Because your secrets deserve public humiliation

# Colors for maximum shame effect
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Common shameful patterns (add your own shame here)
SHAME_PATTERNS=(
    "API_KEY"
    "SECRET"
    "PASSWORD"
    "TOKEN"
    "PRIVATE_KEY"
    "AWS_ACCESS"
    "DATABASE_URL"
    "CREDENTIALS"
    "ENCRYPT"
    "SIGNATURE"
)

# Files to shame-check (because .env is where shame hides)
SHAME_FILES=(".env" ".env.example" ".env.local" "config.env")

# The main shame function
shame_check() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${YELLOW}No shame found in $file (file doesn't exist)${NC}"
        return
    fi
    
    echo -e "\n${RED}🔍 SHAMING: $file${NC}"
    echo "========================================"
    
    local shame_count=0
    local line_num=1
    
    while IFS= read -r line; do
        for pattern in "${SHAME_PATTERNS[@]}"; do
            # Case-insensitive grep for shame
            if echo "$line" | grep -qi "$pattern"; then
                # Skip commented lines (they're trying to be good)
                if [[ ! "$line" =~ ^[[:space:]]*# ]]; then
                    echo -e "${RED}SHAME LINE $line_num:${NC} $line"
                    ((shame_count++))
                    break
                fi
            fi
        done
        ((line_num++))
    done < "$file"
    
    if [[ $shame_count -eq 0 ]]; then
        echo -e "${GREEN}✅ No shame detected! You're a responsible developer!${NC}"
    else
        echo -e "\n${RED}🚨 TOTAL SHAME: $shame_count potential secrets exposed!${NC}"
        echo -e "${YELLOW}💡 Tip: Use .gitignore or git-secrets before committing!${NC}"
    fi
}

# Main execution - shame all the files!
echo -e "${YELLOW}=== ENVIRONMENT VARIABLE SHAMER ===${NC}"
echo "Because your mom shouldn't see your AWS keys on GitHub"
echo ""

for file in "${SHAME_FILES[@]}"; do
    shame_check "$file"
done

# Optional: Check current directory for any .env files
find . -name "*.env*" -type f 2>/dev/null | while read -r found_file; do
    # Skip already checked files
    skip=false
    for checked in "${SHAME_FILES[@]}"; do
        if [[ "$found_file" == "./$checked" ]]; then
            skip=true
            break
        fi
    done
    
    if [[ "$skip" == false ]]; then
        shame_check "$found_file"
    fi
done

echo -e "\n${GREEN}Shaming complete. Go forth and commit responsibly!${NC}"
