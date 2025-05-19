echo "Welcome"
while true; do
  # Asking user to choose an option
  echo "Enter your choice:"
  echo "1. Create new file"
  echo "2. Access a file"
  echo "3. Check all accessible files"
  echo "4. EXIT"

  # Reading choice
  read -p "Choice: " choice

  # Executing function based on user choice
  case "$choice" in
    "1")
      # Asking user to type filename
      echo "Type the filename:"
      read filename

      # Asking user to type contents to the file
      echo "Type the contents in the file (press Ctrl+D to finish):"
      cat > "$filename"

      # Asking user to type password
      echo "Type the password:"
      read password

      # Store filename and password in `files.csv` file
      echo "$filename,$password" >> files.csv
      echo "File created successfully."
      ;;
    "2")
      echo "Type the file you want to access:"
      read filename

      # Setting found to 0 to verify at the end if file was found or not
      found=0

      # Read the `files.csv` line by line, using IFS to split on `,`
      while IFS=, read -r file pass; do
        # Verifying if the file exists
        if [ "$file" = "$filename" ]; then
          # If file exists, set `found=1` indicating file is found
          found=1
          echo "File found: $file"
          # Giving user 3 attempts to type the correct password
          attempts=3
          while [ $attempts -gt 0 ]; do
            echo -n "Type the password: "
            # Reading password directly from the terminal
            read -s user_pass < /dev/tty
            echo
            # Verifying if the given password is correct
            if [ "$user_pass" = "$pass" ]; then
              echo "Access granted. File contents:"
              echo "---------------------------------------------------------------------"
              cat "$filename"
              echo "---------------------------------------------------------------------"
              # Exit password loop and file search loop
              break 2
            else
              # Reducing attempts for each unsuccessful password attempt
              attempts=$((attempts - 1))
              if [ $attempts -gt 0 ]; then
                echo "Wrong password. $attempts attempts left."
              else
                # If all attempts are over, display message
                echo "All attempts over."
              fi
            fi
          done
          break
        fi
      done < files.csv

      # If file not found, display "File not found"
      if [ "$found" -eq 0 ]; then
        echo "File not found."
      fi
      ;;
    "3")
      i=1
      echo "All accessible files:"
      # Read the `files.csv` file line by line
      echo "-----------------------------"
      echo "FILENAME"
      while IFS=, read -r filename _; do
      echo "$i. $filename"
      i=$((i+1))
      done < files.csv
      echo "-----------------------------"
      ;;
    "4")
      # Exiting program
      echo "Exiting program."
      exit 0
      ;;
    *)
      # Invalid choice message
      echo "Invalid choice."
      ;;
  esac
done
