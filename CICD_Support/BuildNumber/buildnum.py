#!/usr/bin/env python3

import os
# import json
# from urllib import request, error, parse
import re
import argparse
import subprocess


def fetchAllTags():
	result = subprocess.run(['git', 'tag', '-l'], capture_output=True, text=True,)
	rawTags = result.stdout.split("\n")
	tags = set(rawTags)

	return tags

def filterTags(allTags, prefix):
	selectedTags = set()

	for tag in allTags:
		digits = re.findall(fr"^{prefix}\d+$", tag)
		if digits:
			selectedTags.add(tag)

	return selectedTags

def getLargestBuildNumber(prefix):
	allTags = fetchAllTags()
	selectedTags = filterTags(allTags, prefix)

	largestBuildNumber = 0
	for selectedTag in selectedTags:
		digits = re.findall(r"\d+$", selectedTag)
		if digits:
			buildNumber = int(digits[0])
			largestBuildNumber = max(largestBuildNumber, buildNumber)

	return largestBuildNumber


parser = argparse.ArgumentParser(description='Build number calculator. Gets the latest build number from tags in a repository.')

# parser.add_argument('--repo', help="The name of the repository")
# parser.add_argument('--account', help="The name of the GitHub account")
parser.add_argument('--tag-prefix', help="If your tag format is 'ac-build-101', this would be `ac-build-`")

args = parser.parse_args()

print(getLargestBuildNumber(args.tag_prefix))
