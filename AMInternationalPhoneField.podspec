Pod::Spec.new do |spec|
  spec.name         = 'AMInternationalPhoneField'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/ntnmrndn/AMInternationalPhoneField'
  spec.authors      = { 'Antoine Marandon' => 'antoine@marandon.fr' }
  spec.summary      = 'A phone number texfield'
  spec.source       = { :git => 'https://github.com/ntnmrndn/AMInternationalPhoneField', :tag => spec.version }
  spec.source_files = 'AMInternationalPhoneField/PodSources/*'
  spec.dependency 'libPhoneNumber-iOS'
  spec.resource_bundles = {
    'AMInternationalPhoneField' => ['AMInternationalPhoneField/PodSources/AMCountries.json']
  }
  spec.platform = :ios
  spec.ios.deployment_target  = '8.0'
end
