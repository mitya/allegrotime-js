namespace :data do
  task :import do
    csv_file  = "data/schedule_20160416.csv"
    date = '2016-04-16'
    trains_count = 18

    data = CSV.read(csv_file, col_sep: ',')
    headers = data.shift

    dataset = {}
    dataset['alert'] = nil
    dataset['updated_at'] = date
    dataset['trains'] = headers[4, trains_count].map(&:to_i)
    dataset['train_rules'] = {
      '7206': 'SV',
      '7203': 'SV',
      '7209': 'PSV'
    }
    dataset['crossings'] = data.map do |row|
      {
        name: row[0],
        distance: row[1].to_i,
        lat: row[2].to_f,
        lng: row[3].to_f,
        updated_at: row[-1],
        closings: row[4, trains_count]
      }
    end

    File.write "data/schedule.json", JSON.pretty_generate(dataset)
    File.write "data/schedule_timestamp.json", JSON.pretty_generate(updated_at: date)
    File.write "source/js/data.js", "var AllegroTime_Data = #{JSON.pretty_generate(dataset)}"
  end

  task :convert_tabs do
    input = "811 1040 1411 1426 1620 1926 1949 2201 2326 646 815 1045 1531 1545 1825 2031 2055"
    output = input.gsub(' ', "\t").gsub(/(\d?\d)(\d\d)/, '\1:\2')
    puts output
  end
end
