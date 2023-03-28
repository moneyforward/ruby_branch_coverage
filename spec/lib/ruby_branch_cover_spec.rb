require "spec_helper"
require "ruby_branch_cover"

RSpec.describe RubyBranchCover do
  it "check line already present in list of lineToCover element" do
    lineToCoverElement1 = {lineNumber:12 , covered: true , branchesToCover: 12, coveredBranches:12}
    lineToCoverElement2 = {lineNumber:34 , covered: false , branchesToCover: 3, coveredBranches:1}
    lineToCoverElement3 = {lineNumber:45 , covered: true , branchesToCover: 6, coveredBranches:6}
    lineArray = []
    lineArray.push(lineToCoverElement1)
    lineArray.push(lineToCoverElement2)
    lineArray.push(lineToCoverElement3)
    c1format = RubyBranchCover.new
    index = c1format.send :check_for_duplicate_line, 34, lineArray
    expect(index).to eq 1
  end

  it "check line which is not in file-> list of lineToCover element" do
    lineToCoverElement1 = {lineNumber:12 , covered: true , branchesToCover: 12, coveredBranches:12}
    lineToCoverElement2 = {lineNumber:34 , covered: false , branchesToCover: 3, coveredBranches:1}
    lineToCoverElement3 = {lineNumber:45 , covered: true , branchesToCover: 6, coveredBranches:6}
    lineArray = []
    lineArray.push(lineToCoverElement1)
    lineArray.push(lineToCoverElement2)
    lineArray.push(lineToCoverElement3)
    c1format = RubyBranchCover.new
    index = c1format.send :check_for_duplicate_line, 55, lineArray
    expect(index).to eq -1
  end

  it "find not covered branches in a condition" do
    conditionmap =  {
      "[:then, 1, 11, 16, 11, 26]": 0,
      "[:else, 2, 10, 12, 12, 15]": 20,
      "[:else, 3, 10, 12, 12, 15]": 0
    }
    c1format = RubyBranchCover.new
    not_covered = c1format.send :find_notcovered_branches, conditionmap
    expect(not_covered).to eq 2
  end

  it "input json file and generate xml file" do
    c1format = RubyBranchCover.new
    output = c1format.read_json_and_getxml("spec/lib/upload/.resultset.json", 1)
    expect(output).to eq(true)
  end

  it "input json file and generate xml file with more than 1 parallel testing" do
    c1format = RubyBranchCover.new
    output = c1format.read_json_and_getxml("spec/lib/upload/.resultset4.json", 3)
    expect(output).to eq(true)
  end

  it "input empty json file and generate xml file" do
    c1format = RubyBranchCover.new
    output = c1format.read_json_and_getxml("spec/lib/upload/.resultset2.json", 1)
    expect(output).to eq(false)
  end

  it "input [no branches,only lines] json file and generate xml file" do
    c1format = RubyBranchCover.new
    output = c1format.read_json_and_getxml("spec/lib/upload/.resultset3.json", 1)
    expect(output).to eq(false)
  end
end
