namespace :data do
  task :import do
    csv_file  = "assets/data/schedule_20170710.csv"
    date = '2017-07-13'
    trains_count = 18

    data = CSV.read(csv_file, col_sep: ';')
    headers = data.shift

    dataset = {}
    dataset['alert'] = nil
    dataset['updated_at'] = date
    dataset['trains'] = headers[4, trains_count].map(&:to_i)
    dataset['train_rules'] = {
      '7206': 'SV',
      '7203': 'SV'
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

    dataset_v1 = {}
    dataset_v1['alert'] = nil
    dataset_v1['updated_at'] = date
    dataset_v1['trains'] = headers[4, trains_count].map(&:to_i)
    dataset_v1['rows'] = data.map do |row|
      row[1] = row[1].to_i
      row[2] = row[2].to_f
      row[3] = row[3].to_f
      row
    end

    File.write "assets/data/schedule.json", JSON.pretty_generate(dataset_v1)
    File.write "assets/data/schedule_v2.json", JSON.pretty_generate(dataset)
    File.write "assets/data/schedule_timestamp.json", JSON.pretty_generate(updated_at: date)
    File.write "src/models/data.js", "module.exports = #{JSON.pretty_generate(dataset)}"
  end

  task :copy_to_site do
    cp "assets/data/schedule.json", "../site/source/data/"
    cp "assets/data/schedule_v2.json", "../site/source/data/"
    cp "assets/data/schedule_timestamp.json", "../site/source/data/"
  end

  task :convert_tabs do
    input = "811 1040 1411 1426 1620 1926 1949 2201 2326 646 815 1045 1531 1545 1825 2031 2055"
    output = input.gsub(' ', "\t").gsub(/(\d?\d)(\d\d)/, '\1:\2')
    puts output
  end
end
