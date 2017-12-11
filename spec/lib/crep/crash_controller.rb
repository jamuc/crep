require 'spec_helper'

RSpec.describe Crep::CrashController do
  subject do
    Class.new(Crep::CrashController) do
      def initialize; end
    end
  end

  describe 'crash_report' do
    let(:crash_controller) { subject.new }
    let(:line) { 'line:123' }
    let(:crash_occurances) { 125 }
    let(:crash_reason) { 'Unknown' }
    let(:crash_class_) { 'SomeWeirdClass' }
    let(:crash_instance) { Crep::Crash.new(file_line: line, occurrences: crash_occurances, reason: crash_reason, crash_class: crash_class_) }
    let(:random_array) { %w[some random array] }
    let(:crash_percentage) { 5.124 }
    let(:app_version) { '1.0.19' }

    it 'should return a correct result' do
      result = crash_controller.crash_report(crash: crash_instance, percentage: crash_percentage, version: app_version)
      expect(result).to eql(["Class: #{crash_class_}", "Occurrences: #{crash_occurances}", "Percentage: #{crash_percentage.round(2)}% of all #{app_version} crashes", "File/Line: #{line}", "Reason: #{crash_reason}"])
    end

    it 'should raise when crash is not defined correctly' do
      expect do
        crash_controller.crash_report(crash: random_array, percentage: crash_percentage, version: app_version)
      end.to raise_exception('Crash info does not fulfill the requirements')
    end
  end

  describe 'crash_percentage' do
    let(:line) { 'line:123' }
    let(:crash_occurances) { 50 }
    let(:crash_reason) { 'Unknown' }
    let(:crash_class_) { 'SomeWeirdClass' }
    let(:crash_instance) { Crep::Crash.new(file_line: line, occurrences: crash_occurances, reason: crash_reason, crash_class: crash_class_) }
    let(:total) { 150 }
    it 'should calculate crash percentage' do
      result = subject.new.crash_percentage(crash: crash_instance, total_crashes: total)
      expect(result).to eql(crash_occurances / total.to_f * 100)
    end
  end

  describe 'crashes_report' do
    let(:line) { 'line:123' }
    let(:crash_occurances) { 50 }
    let(:crash_reason) { 'Unknown' }
    let(:crash_class_) { 'SomeWeirdClass' }
    let(:crash_class_2) { 'SomeOtherClass' }
    let(:crash_instance) { Crep::Crash.new(file_line: line, occurrences: crash_occurances, reason: crash_reason, crash_class: crash_class_) }
    let(:crash_instance_2) { Crep::Crash.new(file_line: line, occurrences: crash_occurances, reason: crash_reason, crash_class: crash_class_2) }

    it 'should receive array of crashes and return result' do
      result = subject.new.crashes_report(crashes: [crash_instance, crash_instance_2], total_crashes: 150, version: '0.0.1')
      expect(result).to eql([['Class: SomeWeirdClass', 'Occurrences: 50', 'Percentage: 33.33% of all 0.0.1 crashes', 'File/Line: line:123', 'Reason: Unknown'], ['Class: SomeOtherClass', 'Occurrences: 50', 'Percentage: 33.33% of all 0.0.1 crashes', 'File/Line: line:123', 'Reason: Unknown']])
    end
  end

  describe 'report' do
    let(:line) { 'line:123' }
    let(:crash_occurances) { 50 }
    let(:crash_occurances_2) { 100 }
    let(:crash_reason) { 'Unknown' }
    let(:crash_class_) { 'SomeWeirdClass' }
    let(:crash_class_2) { 'SomeOtherClass' }
    let(:crash_instance) { Crep::Crash.new(file_line: line, occurrences: crash_occurances, reason: crash_reason, crash_class: crash_class_) }
    let(:crash_instance_2) { Crep::Crash.new(file_line: line, occurrences: crash_occurances_2, reason: crash_reason, crash_class: crash_class_2) }
    let(:expected_output) do
      "Reporting for name (0.1.14/5) identifier.app\n
------------- #1 --------------
Class: SomeWeirdClass
Occurrences: 50
Percentage: 12.5% of all 0.1.14 crashes
File/Line: line:123
Reason: Unknown\n
------------- #2 --------------
Class: SomeOtherClass
Occurrences: 100
Percentage: 25.0% of all 0.1.14 crashes
File/Line: line:123
Reason: Unknown\n"
    end

    it 'should output the result' do
      expect do
        subject.new.report(crashes: [crash_instance, crash_instance_2], total_crashes: 400, app_name: 'name', identifier: 'identifier.app', version: '0.1.14', build: 5)
      end.to output(expected_output).to_stdout
    end

    it 'should receive array of crashes and return result' do
      result = subject.new.report(crashes: [crash_instance, crash_instance_2], total_crashes: 400, app_name: 'name', identifier: 'identifier.app', version: '0.1.14', build: 5)
      expect(result).to eql([['Class: SomeWeirdClass', 'Occurrences: 50', 'Percentage: 12.5% of all 0.1.14 crashes', 'File/Line: line:123', 'Reason: Unknown'], ['Class: SomeOtherClass', 'Occurrences: 100', 'Percentage: 25.0% of all 0.1.14 crashes', 'File/Line: line:123', 'Reason: Unknown']])
    end
  end

  describe 'top_crashes' do
    let(:crash_controller) { subject.new }
    let(:line) { 'line:123' }
    let(:crash_occurances) { 50 }
    let(:crash_occurances_2) { 100 }
    let(:crash_reason) { 'Unknown' }
    let(:crash_class_) { 'SomeWeirdClass' }
    let(:crash_class_2) { 'SomeOtherClass' }
    let(:crash_instance) { Crep::Crash.new(file_line: line, occurrences: crash_occurances, reason: crash_reason, crash_class: crash_class_) }
    let(:crash_instance_2) { Crep::Crash.new(file_line: line, occurrences: crash_occurances_2, reason: crash_reason, crash_class: crash_class_2) }
    let(:expected_output) do
      "Reporting for app_name (0.1.19/1114) bundle.id\n
------------- #1 --------------
Class: SomeWeirdClass
Occurrences: 50
Percentage: 33.33% of all 0.1.19 crashes
File/Line: line:123
Reason: Unknown\n
------------- #2 --------------
Class: SomeOtherClass
Occurrences: 100
Percentage: 66.67% of all 0.1.19 crashes
File/Line: line:123
Reason: Unknown\n"
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
      expect(subject.new.top_crashes('0.1.19', 1114)).to eql([['Class: SomeWeirdClass', 'Occurrences: 50', 'Percentage: 33.33% of all 0.1.19 crashes', 'File/Line: line:123', 'Reason: Unknown'], ['Class: SomeOtherClass', 'Occurrences: 100', 'Percentage: 66.67% of all 0.1.19 crashes', 'File/Line: line:123', 'Reason: Unknown']])
    end
  end
end
