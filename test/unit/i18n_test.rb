require File.expand_path('../test_helper', __dir__)

module Redmine
  class I18nTest < Redmine::HelperTest
    include Redmine::I18n

    def setup
      User.current = nil
    end

    def teardown
      set_language_if_valid 'en'
    end

    def test_valid_languages
      assert valid_languages.is_a?(Array)
      assert valid_languages.first.is_a?(Symbol)
    end

    def test_locales_validness
      lang_files_count = Dir[Rails.root.join('plugins',
                                             'additionals',
                                             'config',
                                             'locales',
                                             '*.yml')].size
      assert_equal lang_files_count, 7
      valid_languages.each do |lang|
        assert set_language_if_valid(lang)
      end
      # check if parse error exists
      ::I18n.locale = 'de'
      assert_equal 'Externe URLs', l(:label_external_urls)
      ::I18n.locale = 'en'
      assert_equal 'External urls', l(:label_external_urls)
      ::I18n.locale = 'fr'
      assert_equal 'Les urnes externes', l(:label_external_urls)
      ::I18n.locale = 'it'
      assert_equal 'Esterno urls', l(:label_external_urls)
      ::I18n.locale = 'ja'
      assert_equal '外部URL', l(:label_external_urls)
      ::I18n.locale = 'zh-TW'
      assert_equal '外部連結', l(:label_external_urls)
      ::I18n.locale = 'zh'
      assert_equal '外部 URLs', l(:label_external_urls)

      set_language_if_valid('en')
    end
  end
end
