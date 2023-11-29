#!/usr/bin/env sh

_() {
  YEAR="2017"
  echo "GitHub Username: "
  read -r USERNAME
  echo "GitHub Access token: "
  read -r ACCESS_TOKEN

  [ -z "$USERNAME" ] && exit 1
  [ -z "$ACCESS_TOKEN" ] && exit 1  
  [ ! -d $YEAR ] && mkdir $YEAR

  cd "${YEAR}" || exit
  git init
  git config core.autocrlf false  # Disables automatic CRLF conversion on Windows
  echo "**${YEAR}** - Generate by https://github.com/TI-ERX/script-several-commits" \
    >README.md
  git add README.md
  
  # Commit for the days of March
  for DAY in {1..31}
  do
    # Checks if the day is in March
    if [ $DAY -ge 1 ] && [ $DAY -le 31 ]; then
      echo "Content for ${YEAR}-03-${DAY}" > "day${DAY}.txt"
      git add "day${DAY}.txt"
      GIT_AUTHOR_DATE="${YEAR}-03-${DAY}T18:00:00" \
        GIT_COMMITTER_DATE="${YEAR}-03-${DAY}T18:00:00" \
        git commit -m "Commit for ${YEAR}-03-${DAY}"
    fi
  done

  git remote add origin "https://${ACCESS_TOKEN}@github.com/${USERNAME}/${YEAR}.git"
  git branch -M main
  git push -u origin main -f
  cd ..
  rm -rf "${YEAR}"

  echo
  echo "Good, now check your profile: https://github.com/${USERNAME}"
} && _

unset -f _
