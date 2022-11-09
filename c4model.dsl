workspace {

    model {
        # people
        editor = person "Editor" "A person that views, creates and modify documents" "User"
        reviewer = person "Reviewer" "A person that reviews documents" "User"
        
        # external systems
        email_system = softwareSystem "Email System" "Email sending system provider, e.g. Mailgun or any system implementing SMTP protocol" "External System" {
            
        }

        drs = softwareSystem "Document Registry System (DRS)" "External system to keep documents" "External System" {
            
        }
        
        # internal systems 
        my_docs = softwareSystem "MyDocs" "System for managing and reviewing documents" {
            backend = container "Backend Application" "Serves HTTP requests and implements system business logic" "python / flask" {
                graphql_api = component "GraphQL API" "Expose GraphQL API endpint that accepts queries and mutations" "python / flask graphene"
                user_signin_service = component "User Sign In Service" "Enables user log in functionality using CSU" "python"
                user_signup_service = component "User Sign Up Service" "Enables user account registration functionality using CSU" "python"
                document_management_service = component "Document Management Service" "Implements logic for viewing, creating and editing documents by editors" "python"
                document_exporter = component "Document Export Component" "Enables exporting documents to doc/docx files and as a json/xml file in a format provided by 'Aktywne Formularze'" "python"
                document_review_service = component "Document Review Service" "Implements logic for reviewing documents by reviewers" "python"
                notification_sender = component "Notification Sender" "Provides notification templates, calls email system API" "python"
                searcher = component "Search Engine" "Component that provides functionality of robust searching for documents"
                
            }
            frontend_spa = container "Singe Page Application" "Frontend application that provides functionalities for Editors and Reviews" "Javascript React / Apollo GraphQL" {

            }
            database  = container "Relational Database" "Relational Database Management System for storing documents" "PostgreSQL" "DB" {

            }
            elastic_search = container "Searcher Database" "Elastic Search Database System" "ElasticSearch" "DB" {

            }
            
        }
        
        # relationships
        editor -> frontend_spa "Uses"
        reviewer -> frontend_spa "Uses"  

        frontend_spa -> graphql_api "Make API calls" "HTTPS/JSON" "GraphQL"
        graphql_api -> user_signin_service "Use" 
        graphql_api -> user_signup_service "Use"
        graphql_api -> document_management_service "Use"
        graphql_api -> document_review_service "Use"

        user_signup_service -> database "Read and write data" "psycopg2"
        user_signup_service -> notification_sender "Uses"
        notification_sender -> email_system "Make API calls to send emails" "HTTPS/JSON" "REST"
        
        user_signin_service -> database "Read and write data" "psycopg2"
        
        document_management_service -> database "Read and write data" "psycopg"
        document_management_service -> document_exporter "Uses"
        document_management_service -> searcher "Send document"
        document_management_service -> searcher "Find document"
        document_exporter -> drs "Make API calls to store document in the registry" "HTTPS/JSON" "REST" 
        
        document_review_service -> database "Read and write data" "psycopg"
        document_review_service -> searcher "Find document"
        
        searcher -> elastic_search "Read and write data" ""
        
    }


    views {
        systemLandscape {
            include *
            autoLayout
        }    
        systemContext my_docs {
            include *
            autoLayout
        }
        container my_docs "Containers" {
            include *
            # autoLayout
        }
        component backend "Components" {
            include *
            # autoLayout
        }
        styles {
            element "User" {
                shape Person
            }
            element "DB" {
                shape Cylinder
            }
            element "Software System" {
                fontSize 30
            }
            element "External System" {
                background #999999
                # color #999999
            }
            relationship "Event" {
                color #08427b
                fontSize 30
            }
            relationship "RPC" {
                color #08427b
                fontSize 30
            }
            relationship "GraphQL" {
                color #08427b
                fontSize 30
            }
            relationship "Webhook" {
                color #08427b
                fontSize 30
            }
            relationship "Websocket" {
                color #08427b
                fontSize 30
            }
        }
        theme default
        
    }

}