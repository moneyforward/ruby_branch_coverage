# frozen_string_literal: true

require 'json'
require 'builder'

# Convert JSON to XML for branch coverage
class RubyBranchCover
  def read_json_and_getxml(filepath, parallelism_count)
    file = File.read(filepath)
    data_hash = JSON.parse(file)
    file_elements = []
    rspec_key = find_rspec_key parallelism_count

    unless data_hash.empty? || data_hash[rspec_key].nil? || data_hash[rspec_key]['coverage'].nil?
      file_elements = create_file_elements(data_hash[rspec_key]['coverage'])
    end

    create_xml(file_elements)

    file_elements.size.positive?
  end

  private

  def find_rspec_key(count)
    key_to_append = 'RSpec'
    final_key = ''
    count.times do |index|
      final_key += key_to_append
      final_key += ',' if index < (count - 1)
    end

    final_key
  end

  def create_file_elements(coverage_block_by_key)
    file_elements = []
    coverage_block_by_key.each do |filename, value|
      branches = value['branches']

      next if branches.nil? || branches.keys.empty?

      file_element = { path: filename, lineElements: line_to_cover_array(branches) }
      file_elements.push(file_element)
    end

    file_elements
  end

  def line_to_cover_array(branches)
    line_to_cover_array = []
    branches.each do |branch, conditions_map|
      line_number = branch.split(',')[2].strip
      not_covered = find_notcovered_branches conditions_map
      covered = (conditions_map.keys.size - not_covered)

      line_tocover_element = line_tocover_element_by_branch(covered, line_number, conditions_map.keys.size)
      index = check_for_duplicate_line line_number, line_to_cover_array
      update_line_to_cover_array_by_index(line_to_cover_array, index, line_tocover_element)
    end

    line_to_cover_array
  end

  def find_notcovered_branches(conditions_map)
    conditions_map.count { |_condition, hit_count| hit_count.zero? }
  end

  def line_tocover_element_by_branch(covered, line_number, branches_to_cover)
    {
      lineNumber: line_number,
      covered: covered.positive?,
      branchesToCover: branches_to_cover,
      coveredBranches: covered
    }
  end

  # To check line already present in list of lineToCover element
  def check_for_duplicate_line(line_number, line_tocover_elements)
    line_tocover_elements.each_with_index do |element, idx|
      return idx if element[:lineNumber] == line_number
    end

    -1
  end

  def update_line_to_cover_array_by_index(line_to_cover_array, index, line_tocover_element)
    return line_to_cover_array.push(line_tocover_element) if index == -1

    # if index == -1
    #   line_to_cover_array.push(line_tocover_element)
    # else
    old_line_tocover_element = line_to_cover_array[index]
    old_line_tocover_element[:branchesToCover] =
      old_line_tocover_element[:branchesToCover] + line_tocover_element[:branchesToCover]
    old_line_tocover_element[:coveredBranches] =
      old_line_tocover_element[:coveredBranches] + line_tocover_element[:coveredBranches]
    old_line_tocover_element[:covered] = old_line_tocover_element[:covered] && line_tocover_element[:covered]
    line_to_cover_array[index] = old_line_tocover_element
    # end
  end

  # def update_line_to_cover_array()
  #
  # end

  def create_xml(file_elements)
    xml = Builder::XmlMarkup.new(indent: 2)
    puts "Total Files: #{file_elements.size}"
    prepare_xml_builder xml, file_elements
    File.write('coverage/branch-coverage.xml', xml.target!)
  end

  def prepare_xml_builder(xml, file_elements)
    xml.coverage('version' => '1') do
      file_elements.each do |file_element|
        xml.file('path' => file_element[:path]) do
          file_element[:lineElements].each do |element|
            xml.lineToCover(line_to_cover_hash(element))
          end
        end
      end
    end
  end

  def line_to_cover_hash(element)
    {
      'lineNumber' => element[:lineNumber],
      'covered' => element[:covered],
      'branchesToCover' => element[:branchesToCover],
      'coveredBranches' => element[:coveredBranches]
    }
  end
end
