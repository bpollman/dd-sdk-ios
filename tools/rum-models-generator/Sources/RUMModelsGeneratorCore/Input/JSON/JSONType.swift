/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at Datadog (https://www.datadoghq.com/).
* Copyright 2019-2020 Datadog, Inc.
*/

import Foundation

/// Type-safe JSON schema.
internal protocol JSONType {}

internal enum JSONPrimitive: String, JSONType {
    case bool
    case double
    case integer
    case string
}

internal struct JSONArray: JSONType {
    let element: JSONType
}

internal struct JSONEnumeration: JSONType {
    let name: String
    let comment: String?
    let values: [String]
}

internal struct JSONObject: JSONType {
    struct Property: JSONType {
        enum DefaultValue {
            case integer(value: Int)
            case string(value: String)
        }

        let name: String
        let comment: String?
        let type: JSONType
        let defaultVaule: DefaultValue?
        let isRequired: Bool
        let isReadOnly: Bool
    }

    let name: String
    let comment: String?
    let properties: [Property]

    init(name: String, comment: String?, properties: [Property]) {
        self.name = name
        self.comment = comment
        self.properties = properties.sorted { property1, property2 in property1.name < property2.name }
    }
}

// MARK: - Equatable

extension JSONObject: Equatable {
    static func == (lhs: JSONObject, rhs: JSONObject) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
