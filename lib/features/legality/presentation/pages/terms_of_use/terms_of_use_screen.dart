import 'package:flutter/material.dart';
import 'package:ppidunia/features/legality/presentation/pages/terms_of_use/terms_of_use_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/extension.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:ppidunia/features/legality/presentation/pages/terms_of_use/terms_of_use_state.dart';

class TermsOfUseScreenState extends State<TermsOfUseScreen> {
  late TermsOfUseScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<TermsOfUseScreenModel>();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: GreyBackgroundWidget(
          screenSize: screenSize,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            getTranslated('BACK'),
                            style: sfProRegular.copyWith(
                              color: ColorResources.primaryButton,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            getTranslated('TERM_OF_USE').toTitleCase(),
                            style: sfProRegular.copyWith(
                              fontSize: Dimensions.fontSizeTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: ColorResources.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              'Welcome to PPI Dunia, a mobile application developed by Inovatif78. We are delighted to have you as a user of our app. Before you start using the PPI Dunia mobile application, please carefully read and agree to these Terms of Use ("Terms") as they constitute a legal agreement between you ("User" or "you") and Inovatif78 ("we," "us," or "our"). ',
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "1. Acceptance of Terms: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "By using the PPI Dunia mobile application, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy. If you do not agree to these Terms or the Privacy Policy, please do not use the PPI Dunia application. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "2. Description of PPI Dunia: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "PPI Dunia is a mobile application that provides its users with a platform to interact with each other. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "3. License and Applicability: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "Subject to your compliance with these Terms, we grant you a limited, non-exclusive, non-transferable, and revocable license to use the PPI Dunia mobile application for your personal, non-commercial use. You must be at least 18 years old or the age of majority in your jurisdiction to use the PPI Dunia application. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "4. User Conduct: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "While using the PPI Dunia application, you agree to: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.marginSizeSmall,
                                  bottom: Dimensions.marginSizeSmall),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "a. Provide accurate and up-to-date information during the registration process. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "b. Maintain the security of your account and promptly notify us if you discover any unauthorized access or breach of security. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "c. Use the application for lawful purposes and not engage in any illegal, harmful, or deceptive activities. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "d. Respect the intellectual property rights of PPI Dunia, Inovatif78, and third parties. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "5. Prohibited Activities: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "In connection with your use of the PPI Dunia application, you expressly agree not to: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.marginSizeSmall,
                                  bottom: Dimensions.marginSizeSmall),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "a. Violate any applicable law, regulation, or rights of any third party. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "b. Modify, adapt, translate, or reverse engineer any portion of the application. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "c. Remove or alter any copyright, trademark, or other proprietary rights notices contained within the application. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "d. Use any automated means, including bots, crawlers, or scrapers, to access or collect data from the application. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                  Text(
                                    "e. Transmit any viruses, malware, or other harmful computer code. ",
                                    textAlign: TextAlign.justify,
                                    style: sfProRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "6. Your Content: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "You retain ownership of any content you submit, post, or display on or through the PPI Dunia application. By doing so, you grant us a non-exclusive, worldwide, royalty-free license (with the right to sublicense) to use, copy, reproduce, process, adapt, modify, publish, transmit, display, and distribute such content for the purpose of providing and improving the PPI Dunia application and promoting Inovatif78. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "7. Third-Party Services: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "The PPI Dunia application may contain links to third-party websites or services that are not owned or controlled by Inovatif78. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You further acknowledge and agree that Inovatif78 shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "8. Modification and Termination: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "We reserve the right to modify or terminate the PPI Dunia application or these Terms of Use at any time, without notice, and for any reason. We may also suspend or terminate your access to the application if you violate these Terms or for any other reason whatsoever. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "9. Indemnification: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "You agree to indemnify and hold harmless Inovatif78 and its officers, directors, employees, and agents, from and against any claims, suits, proceedings, disputes, demands, liabilities, damages, losses, costs, and expenses, including reasonable attorneys' fees, arising out of or in any way connected with your use of the PPI Dunia application, any content you submit, post, or transmit through the application, your violation of these Terms, or your violation of any rights of another. ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "10. Disclaimer: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              'THE PPI DUNIA APPLICATION IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED. INOVATIF78 DISCLAIMS ALL WARRANTIES, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. WHILE WE STRIVE TO PROVIDE ACCURATE AND UP-TO-DATE INFORMATION THROUGH THE APPLICATION, WE DO NOT WARRANT THAT THE CONTENT OR INFORMATION AVAILABLE ON THE APPLICATION IS ACCURATE, COMPLETE, RELIABLE, CURRENT, OR ERROR-FREE. ',
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "11. Limitation of Liability: ",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              'TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, INOVATIF78 AND ITS OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING, BUT NOT LIMITED TO, LOSS OF PROFITS, DATA, USE, GOODWILL, OR OTHER INTANGIBLE LOSSES, ARISING OUT OF OR IN CONNECTION WITH YOUR USE OF THE PPI DUNIA APPLICATION, REGARDLESS OF WHETHER INOVATIF78 HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. ',
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "Contact Us",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.marginSizeSmall,
                                bottom: Dimensions.marginSizeSmall),
                            child: Text(
                              "If you have any questions or suggestions about our Term of Use, do not hesitate to contact us at customercare@inovasi78.com",
                              textAlign: TextAlign.justify,
                              style: sfProRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
