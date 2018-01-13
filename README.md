# Crep

*Crep - a Crash Reporter for creating appealing Crash Newsletters*

We use Crep at [XING](https://www.xing.com) to create our Crash Newsletters for [iOS](https://www.xing.com/ios) and [Android](https://www.xing.com/android) within the _Mobile Releases Team_. It currently uses [HockeyApp](https://rink.hockeyapp.net) as a crash source, so if you are using Hockey, you should definitely give Crep a try.

In case you are creating Crash Newsletters and have a different crash source in mind - check out the contributing section!

## Install

Please follow our guide in the [Installation Instructions](https://github.com/xing/crep/wiki/Install).

## Usage

Provide a `CREP_HOCKEY_API_TOKEN`: 

`export CREP_HOCKEY_API_TOKEN='abcde'`

Run Crep:

`bundle exec crep crashes --identifier='com.example.company' --version='1.23.0' --build='42' --only-unresolved`

The `--only-unresolved` flag filters out any crashes marked as resolved.

That's how [Crep output](https://github.com/xing/crep/blob/master/spec/fixtures/report_output.txt) can look like.

## Test

Run `bundle exec rspec` in order to run the tests.

## Contributing

🎁 Bug reports and pull requests for new features are most welcome!

👷🏼 In case you want to use a different crash source - feel free to add on, we are looking forward to your pull request, we'd love to help!

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
