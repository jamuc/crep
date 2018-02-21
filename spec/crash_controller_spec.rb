require 'spec_helper'

expected_occurrences = 'First appeared on 2017-07-14 and occurred 50 times in 0.0.1'
expected_link = 'Link: https://my.crash.url'

RSpec.describe Crep::CrashController do
  subject do
    Class.new(Crep::CrashController) do
      def initialize; end
    end
  end
  let(:crash_controller) { subject.new }
  let(:line) { 'line:123' }
  let(:crash_url) { 'https://my.crash.url' }
  let(:deep_link) { 'hockeyapp-coach://view-crash/app_id/reason_id/latest' }
  let(:crash_class) { 'SomeWeirdClass' }
  let(:crash_reason) { 'Unknown' }

  describe 'crash_report' do
    let(:crash_occurrences) { 125 }
    let(:crash_date) { Date.parse('2017-07-14') }
    let(:crash_instance) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences,
                      reason: crash_reason,
                      crash_class: crash_class,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end

    let(:random_array) { %w[some random array] }
    let(:crash_percentage) { 5.124 }
    let(:app_version) { '1.0.19' }

    it 'should return a correct result' do
      result = crash_controller.crash_report(crash: crash_instance, percentage: crash_percentage, version: app_version)
      expect(result).to eql(["Class: #{crash_class}",
                             "First appeared on #{crash_date} and occurred #{crash_occurrences} times in #{app_version}",
                             "Percentage: #{crash_percentage.round(2)}% of all #{app_version} crashes",
                             "File/Line: #{line}", "Reason: #{crash_reason}", expected_link, "Deep Link: #{deep_link}"])
    end

    it 'should raise when crash is not defined correctly' do
      expect do
        crash_controller.crash_report(crash: random_array, percentage: crash_percentage, version: app_version)
      end.to raise_exception('Crash info does not fulfill the requirements')
    end
  end

  describe 'crash_percentage' do
    let(:crash_occurrences) { 50 }
    let(:crash_date) { Date.parse('2017-07-14') }
    let(:crash_instance) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences,
                      reason: crash_reason,
                      crash_class: crash_class,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end

    let(:total) { 150 }

    it 'should calculate crash percentage' do
      result = subject.new.crash_percentage(crash: crash_instance, total_crashes: total)
      expect(result).to eql(crash_occurrences / total.to_f * 100)
    end
  end

  describe 'crashes_report' do
    let(:crash_occurrences) { 50 }
    let(:crash_date) { Date.parse('2017-07-14') }
    let(:crash_class_2) { 'SomeOtherClass' }
    let(:crash_instance) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences,
                      reason: crash_reason,
                      crash_class: crash_class,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end
    let(:crash_instance_2) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences,
                      reason: crash_reason,
                      crash_class: crash_class_2,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end

    it 'should receive array of crashes and return result' do
      result = subject.new.crashes_report(crashes: [crash_instance, crash_instance_2], total_crashes: 150, version: '0.0.1')
      expect(result).to eql([
                              [
                                'Class: SomeWeirdClass',
                                expected_occurrences,
                                'Percentage: 33.33% of all 0.0.1 crashes',
                                'File/Line: line:123',
                                'Reason: Unknown',
                                expected_link,
                                "Deep Link: #{deep_link}"
                              ],
                              [
                                'Class: SomeOtherClass',
                                expected_occurrences,
                                'Percentage: 33.33% of all 0.0.1 crashes',
                                'File/Line: line:123',
                                'Reason: Unknown',
                                expected_link,
                                "Deep Link: #{deep_link}"
                              ]
                            ])
    end
  end

  describe 'report' do
    let(:crash_occurrences) { 50 }
    let(:crash_occurrences_2) { 100 }
    let(:crash_date) { Date.parse('2017-07-14') }
    let(:crash_class_2) { 'SomeOtherClass' }
    let(:expected_output) { File.read('spec/fixtures/report_output.txt') }
    let(:crash_instance) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences,
                      reason: crash_reason,
                      crash_class: crash_class,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end
    let(:crash_instance_2) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences_2,
                      reason: crash_reason,
                      crash_class: crash_class_2,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end

    it 'should output the result' do
      expect do
        subject.new.report(crashes: [crash_instance, crash_instance_2], total_crashes: 400, app_name: 'name', identifier: 'identifier.app', version: '0.0.1', build: 5)
      end.to output(expected_output).to_stdout
    end

    it 'should receive array of crashes and return result' do
      result = subject.new.report(crashes: [crash_instance, crash_instance_2], total_crashes: 400, app_name: 'name', identifier: 'identifier.app', version: '0.0.1', build: 5)
      expect(result).to eql([
                              ['Class: SomeWeirdClass', expected_occurrences, 'Percentage: 12.5% of all 0.0.1 crashes', 'File/Line: line:123', 'Reason: Unknown', expected_link, "Deep Link: #{deep_link}"],
                              ['Class: SomeOtherClass', 'First appeared on 2017-07-14 and occurred 100 times in 0.0.1', 'Percentage: 25.0% of all 0.0.1 crashes', 'File/Line: line:123', 'Reason: Unknown', expected_link, "Deep Link: #{deep_link}"]
                            ])
    end
  end

  describe 'top_crashes' do
    let(:crash_occurrences) { 50 }
    let(:crash_occurrences_2) { 100 }
    let(:crash_date) { Date.parse('2017-07-14') }
    let(:crash_class_2) { 'SomeOtherClass' }
    let(:expected_output) { File.read('spec/fixtures/top_crashes_output.txt') }
    let(:crash_instance) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences,
                      reason: crash_reason,
                      crash_class: crash_class,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end
    let(:crash_instance_2) do
      Crep::Crash.new(file_line: line,
                      occurrences: crash_occurrences_2,
                      reason: crash_reason,
                      crash_class: crash_class_2,
                      registered_at: crash_date,
                      deep_link: deep_link,
                      url: crash_url)
    end

    before do
      allow(@crash_source).to receive(:crashes).and_return([crash_instance, crash_instance_2])
      allow(@crash_source).to receive(:crash_count).and_return(150)
      allow(@crash_source).to receive(:app)
      allow(@crash_source.app).to receive(:name).and_return('app_name')
      allow(@crash_source.app).to receive(:bundle_identifier).and_return('bundle.id')
    end

    it 'should output the result based on class variables' do
      expect do
        subject.new.top_crashes('0.1.19', 1114)
      end.to output(expected_output).to_stdout
    end

    it 'should receive info from @crash_source and return result' do
      expect(subject.new.top_crashes('0.1.19', 1114)).to eql([
                                                               [
                                                                 'Class: SomeWeirdClass',
                                                                 'First appeared on 2017-07-14 and occurred 50 times in 0.1.19',
                                                                 'Percentage: 33.33% of all 0.1.19 crashes',
                                                                 'File/Line: line:123',
                                                                 'Reason: Unknown',
                                                                 expected_link,
                                                                 "Deep Link: #{deep_link}"
                                                               ],
                                                               [
                                                                 'Class: SomeOtherClass',
                                                                 'First appeared on 2017-07-14 and occurred 100 times in 0.1.19',
                                                                 'Percentage: 66.67% of all 0.1.19 crashes',
                                                                 'File/Line: line:123',
                                                                 'Reason: Unknown',
                                                                 expected_link,
                                                                 "Deep Link: #{deep_link}"
                                                               ]
                                                             ])
    end
  end
end
