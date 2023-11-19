#!/usr/bin/bash -e

COMMIT_MESSAGE=$(git log -1 --pretty=%B)
ISSUE_REGEX='(#\d+|(APP|DOPS)-[0-9]+)'

if [[ "${SOURCE_BRANCH}" =~ $ISSUE_REGEX ]]; then
  ISSUE_OR_TOKEN=${BASH_REMATCH[1]}
  # Check if it's a GitHub issue number
  if [[ "$ISSUE_OR_TOKEN" == "#*" ]]; then
    PR_BODY="https://github.com/iremote/node-templ/issues/${ISSUE_OR_TOKEN:1}"
  else
    PR_BODY="JIRA Issue: $ISSUE_OR_TOKEN"
  fi
else
  PR_BODY="$COMMIT_MESSAGE"
fi

PR_TITLE="Merge ${SOURCE_BRANCH} into ${DESTINATION_BRANCH} $ISSUE_OR_TOKEN"
gh pr create -B "${DESTINATION_BRANCH}" -H "${SOURCE_BRANCH}" --title "$PR_TITLE" --body "$PR_BODY"
