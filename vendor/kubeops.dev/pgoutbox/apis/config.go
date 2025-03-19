package apis

import (
	"fmt"
	"strings"
	"time"

	"github.com/asaskevich/govalidator"
	"github.com/spf13/viper"
)

type PublisherType string

const (
	PublisherTypeNats         PublisherType = "nats"
	PublisherTypeKafka        PublisherType = "kafka"
	PublisherTypeRabbitMQ     PublisherType = "rabbitmq"
	PublisherTypeGooglePubSub PublisherType = "google_pubsub"
)

// Config for pgoutbox.
type Config struct {
	Listener  *ListenerCfg  `valid:"required" json:"listener" mapstructure:"listener"`
	Database  *DatabaseCfg  `valid:"required" json:"database" mapstructure:"database"`
	Publisher *PublisherCfg `valid:"required" json:"publisher" mapstructure:"publisher"`
	Logger    *Logger       `valid:"required" json:"logger" mapstructure:"logger"`
}

// ListenerCfg path of the listener config.
type ListenerCfg struct {
	SlotName          string            `valid:"required" json:"slotName" mapstructure:"slotName"`
	ServerPort        int               `json:"serverPort" mapstructure:"serverPort"`
	AckTimeout        time.Duration     `json:"ackTimeout" mapstructure:"ackTimeout"`
	RefreshConnection time.Duration     `json:"refreshConnection" valid:"required" mapstructure:"refreshConnection"`
	HeartbeatInterval time.Duration     `json:"heartbeatInterval" valid:"required" mapstructure:"heartbeatInterval"`
	Filter            FilterStruct      `json:"filter" mapstructure:"filter"`
	TopicsMap         map[string]string `json:"topicsMap" mapstructure:"topicsMap"`
}

// PublisherCfg represent configuration for any publisher types.
type PublisherCfg struct {
	Type            PublisherType `valid:"required" json:"type" mapstructure:"type"`
	Address         string        `valid:"required" json:"address" mapstructure:"address"`
	NatsCredPath    string        `valid:"required" json:"natsCredPath" mapstructure:"natsCredPath"`
	Topic           string        `valid:"required" json:"topic" mapstructure:"topic"`
	TopicPrefix     string        `json:"topicPrefix" mapstructure:"topicPrefix"`
	EnableTLS       bool          `json:"enableTLS" mapstructure:"enableTlS"`
	ClientCert      string        `json:"clientCert" mapstructure:"clientCert"`
	ClientKey       string        `json:"clientKey" mapstructure:"clientKey"`
	CACert          string        `json:"CACert" mapstructure:"caCert"`
	PubSubProjectID string        `json:"pubSubProjectID" mapstructure:"pubSubProductId"`
}

// DatabaseCfg path of the PostgreSQL DB config.
type DatabaseCfg struct {
	Host     string `valid:"required" json:"host" mapstructure:"host"`
	Port     uint16 `valid:"required" json:"port" mapstructure:"port"`
	Name     string `valid:"required" json:"name" mapstructure:"name"`
	User     string `valid:"required" json:"user" mapstructure:"user"`
	Password string `valid:"required" json:"password" mapstructure:"password"`
	Debug    bool   `json:"debug" mapstructure:"debug"`
}

// FilterStruct incoming WAL message filter.
type FilterStruct struct {
	Tables map[string][]string `json:"tables" yaml:"tables" mapstructure:"tables"`
}

// Validate config data.
func (c Config) Validate() error {
	_, err := govalidator.ValidateStruct(c)
	return err
}

// InitConfig load config from file.
func InitConfig(path string) (*Config, error) {
	const envPrefix = "WAL"

	var conf Config

	vp := viper.New()

	vp.SetEnvPrefix(envPrefix)
	vp.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	vp.AutomaticEnv()
	vp.SetConfigFile(path)

	if err := vp.ReadInConfig(); err != nil {
		return nil, fmt.Errorf("error reading config: %w", err)
	}

	if err := vp.Unmarshal(&conf); err != nil {
		return nil, fmt.Errorf("unable to decode into config struct: %w", err)
	}

	return &conf, nil
}
