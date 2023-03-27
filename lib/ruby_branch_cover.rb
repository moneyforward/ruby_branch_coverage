require 'json'
require 'builder'

class RubyBranchCover

    # To check line already present in list of lineToCover element
    def check_for_duplicate_line(line_number, line_tocover_elements)
        line_tocover_elements.each_with_index do
            |element, idx|
            if element[:lineNumber] == line_number
                return idx
            end
        end
        return -1
    end

    def find_notcovered_branches(condtions_map)
        not_covered = 0
        condtions_map.each do
            |condition, hitCount|
            if hitCount == 0
                not_covered+=1
            end
        end
        return not_covered
    end

    def prepare_xml_builder(xml, file_elements)
        xml.coverage("version" => "1") do
            file_elements.each do
                |fileElement|
                xml.file("path" => fileElement[:path]) do
                    fileElement[:lineElements].each do
                        |element|
                        xml.lineToCover("lineNumber"=>element[:lineNumber], "covered"=>element[:covered], 
                        "branchesToCover"=>element[:branchesToCover], "coveredBranches"=>element[:coveredBranches])
                    end
                end
            end
        end
    end

    def find_rspec_key(count)
        key_to_append = 'RSpec'
        final_key = ''
        count.times do
            |index| 
            final_key = final_key + key_to_append
            if index < count-1
                final_key = final_key + ','
            end
        end
        return final_key
    end


    def read_json_and_getxml(filepath, parallelism_count)
        file = File.read(filepath)
        data_hash = JSON.parse(file)
        file_elements = []
        rspec_key = find_rspec_key parallelism_count
        unless data_hash.empty? || data_hash[rspec_key] == nil || data_hash[rspec_key]['coverage'] == nil 
            files_map = data_hash[rspec_key]['coverage']
            files_map.each do
                |filename,value| 
                branches = value['branches']
                line_to_cover_array = []
                unless branches == nil || branches.keys.size == 0
                    branches.each do 
                        |branch, condtions_map| 
                        line_number = branch.split(',')[2].strip
                        not_covered = find_notcovered_branches condtions_map
                        covered = condtions_map.keys.size-not_covered
                        line_tocover_element = {lineNumber:line_number , covered: covered > 0 , branchesToCover: condtions_map.keys.size, coveredBranches:covered}
                        index = check_for_duplicate_line line_number, line_to_cover_array
                        if index != -1
                            old_line_tocover_element = line_to_cover_array[index]
                            old_line_tocover_element[:branchesToCover] = old_line_tocover_element[:branchesToCover] + line_tocover_element[:branchesToCover]
                            old_line_tocover_element[:coveredBranches] = old_line_tocover_element[:coveredBranches] + line_tocover_element[:coveredBranches]
                            old_line_tocover_element[:covered] = old_line_tocover_element[:covered] && line_tocover_element[:covered]
                            line_to_cover_array[index] = old_line_tocover_element
                        else
                            line_to_cover_array.push(line_tocover_element)
                        end
                    end
                    file_element = {path: filename, lineElements: line_to_cover_array}
                    file_elements.push(file_element)
                end
            end

            xml = Builder::XmlMarkup.new(:indent => 2)
            puts "Total Files: #{file_elements.size}"
            prepare_xml_builder xml, file_elements
            File.write("coverage/branch-coverage.xml", xml.target!)
            if file_elements.size > 0
                return true
            else
                return false
            end
        else
            xml = Builder::XmlMarkup.new(:indent => 2)
            puts "Total Files: #{file_elements.size}"
            # xml.target!
            prepare_xml_builder xml, file_elements
            File.write("coverage/branch-coverage.xml", xml.target!)
            return false
        end

    end
end
