import adanet
import tensorflow as tf


FEATURES_KEY = "x"


def input_fn(partition, training, batch_size):
  """Generate an input function for the Estimator."""

  def _input_fn():

    if partition == "train":
      dataset = tf.data.Dataset.from_tensor_slices(({
          FEATURES_KEY: tf.log1p(x_train)
      }, tf.log1p(y_train)))
    else:
      dataset = tf.data.Dataset.from_tensor_slices(({
          FEATURES_KEY: tf.log1p(x_test)
      }, tf.log1p(y_test)))

    # We call repeat after shuffling, rather than before, to prevent separate
    # epochs from blending together.
    if training:
      dataset = dataset.shuffle(10 * batch_size, seed=RANDOM_SEED).repeat()

    dataset = dataset.batch(batch_size)
    iterator = dataset.make_one_shot_iterator()
    features, labels = iterator.get_next()
    return features, labels

  return _input_fn

feature_columns = None

estimator = adanet.AutoEnsembleEstimator(
    head=head,
    candidate_pool={
        'linear':
            tf.estimator.LinearEstimator(
                head=head,
                feature_columns=feature_columns,
                optimizer=...)
            )
        'dnn':
            tf.estimator.DNNEstimator(
                head=head,
                feature_columns=feature_columns,
                optimizer=...,
                hidden_units=[1000, 500, 100])},
                max_iteration_steps = 50)

    estimator.train(input_fn = train_input_fn, steps = 100)
    metrics=estimator.evaluate(input_fn = eval_input_fn)
    predictions=estimator.predict(input_fn = predict_input_fn)
    }
)


def main():
    (x_train, y_train), (x_test, y_test)=(tf.keras.datasets.boston_housing.load_data())
    # Preview the first example from the training data
    print('Model inputs: %s \n' % x_train[0])
    print('Model output (house price): $%s ' %(y_train[0] * 1000))
    head=MultiClassHead(n_classes=2)
